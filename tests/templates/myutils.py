# utils.py
import re, time, requests, json
from robot.api import logger
import urllib.parse
from robot.libraries.BuiltIn import BuiltIn
import fcntl
import os
import random
from meraki_request import (
    request_session, request, APIError, APIKeyError,
)

# Constants
API_PATH_ID_REGEX = r'{[a-zA-Z]*}'
API_BASE = "https://api.meraki.com/api/v1"
CACHE_FILE = "cache.json"
LOCK_FILE = "cache.json.lock"
THROTTLE_LOCK_FILE = "meraki_api_throttle.lock"
THROTTLE_SLEEP_SECONDS = 0.1  # Meraki limit = 10 req/sec

def throttle_request():
    lock = FileLock(THROTTLE_LOCK_FILE)
    lock.acquire()
    try:
        time.sleep(THROTTLE_SLEEP_SECONDS)
    finally:
        lock.release()

def to_snake_case(text):
    text = re.sub(r'(?<!^)(?=[A-Z])', '_', text).lower()
    return text

def camel_to_snake(d):
    if isinstance(d, dict):
        ret = {}
        for k, v in d.items():
            ret[to_snake_case(k)] = camel_to_snake(v)
        return ret
    if isinstance(d, list):
        return [camel_to_snake(i) for i in d]
    return d

def is_empty(x):
    if x is None:
        return True
    if (isinstance(x, list) or isinstance(x, dict)) and len(x) == 0:
        return True

def filter_by_whitelist(x, whitelist, path=""):
    if isinstance(x, list):
        return [filter_by_whitelist(elem, whitelist, path=path+f"[{repr(i)}]") for i, elem in enumerate(x)]
    ret = {}
    top_level = list(filter(lambda x: "." not in x, whitelist))
    for t in top_level:
        try:
            ret[t] = x.get(t, None)
        except AttributeError as e:
            raise Exception(f"filter_by_whitelist(path={path}): Failed to get {repr(t)} from {repr(x)}: {e}")
    not_top_level = list(filter(lambda x: "." in x, whitelist))
    first_level = set([i.split(".")[0] for i in not_top_level])
    for f in first_level:
        if f not in x:
            continue
        child_fields = [".".join(i.split(".")[1:]) for i in filter(lambda j: j.startswith(f), whitelist)]
        ret[f] = filter_by_whitelist(x[f], child_fields, path=path+f"[{repr(f)}]")
    return ret

abbreviations = {
    "dest" : "destination",
    "dst" : "destination",
    "src": "source",
    "org": "organization",
    "ip_ver": "ip_version",
}

def unabbreviate_string(s):
    ret = [s]
    for k, v in abbreviations.items():
        if k+"_" in s:
            ret.append(s.replace(k+"_", v+"_"))
        if "_"+k in s:
            ret.append(s.replace("_"+k, "_"+v))
    if "_enabled" in s:
        ret.append(s.replace("_enabled", ""))
    return ret

def unabbreviate_superset(x):
    if isinstance(x, list):
        return [unabbreviate_superset(i) for i in x]
    if isinstance(x, dict):
        ret = {}
        for k, v in x.items():
            keys_to_use = unabbreviate_string(k)
            if k in abbreviations:
                keys_to_use.append(abbreviations[k])
            for kk in keys_to_use:
                ret[kk] = unabbreviate_superset(v)
        return ret
    return x

def _validate_subset(superset, subset, superset_path="", subset_path=""):
    if str(superset) == str(subset):
        return True
    if subset is None:
        return True
    superset = camel_to_snake(superset)
    superset = unabbreviate_superset(superset)
    logger.info(f"Actual superset ({superset_path}): {json.dumps(superset, sort_keys=True, indent=4)}")
    logger.info(f"Expected subset ({subset_path}): {json.dumps(subset, sort_keys=True, indent=4)}")
    if type(superset) != type(subset):
        return False
    if type(subset) == dict:
        for k, v in subset.items():
            if k == "secret" or k == "password":
                continue
            child_superset_path = f"{superset_path}.{k}"
            child_subset_path = f"{subset_path}.{k}"
            if not _validate_subset(superset.get(k, None), v, child_superset_path, child_subset_path):
                return False
        return True
    elif type(subset) == list:
        for subset_i, subset_item in enumerate(subset):
            found = False
            for superset_i, superset_item in enumerate(superset):
                child_superset_path = f"{superset_path}[{superset_i}]"
                child_subset_path = f"{subset_path}[{subset_i}]"
                if _validate_subset(superset_item, subset_item, child_superset_path, child_subset_path):
                    found = True
                    break
            if not found:
                return False
        return True
    else:
        return superset == subset or (is_empty(subset) and is_empty(superset))

def validate_subset(superset, subset, whitelist=[]):
    if len(whitelist) > 0:
        subset = filter_by_whitelist(subset, whitelist)
    return _validate_subset(superset, subset)

def unflatten_dicts(data, add_key):
    """
    Make a single-item dict with add_key as the key and data as the value.
    If data is a list, make each item a single-item dict.

    >>> unflatten_dicts(["a", "b"], "name")
    [{"name": "a"}, {"name": "b"}]

    The usecase is adjusting YAML data
    that is flattened in the .nac.yaml schema compared to Meraki API
    back to a Meraki-API-like format for comparison with the API's response.
    """

    if isinstance(data, list):
        return [{add_key: i} for i in data]

    return {add_key: data}

def unflatten_dicts_in_property(data, prop, add_key):
    """
    Return data with its prop key's value replaced
    with a single-item dict with add_key as the key.
    If data is a list, transform each item's prop key.
    If the prop key's value is a list,
    replace each item with a single-item dict.

    >>> unflatten_dicts_in_property([
        {"acls": ["a", "b"], "organization_name": "Dev"},
        {"acls": ["c", "d"]},
    ], "acls", "name")
    [
        {"acls": [{"name": "a"}, {"name": "b"}], "organization_name": "Dev"},
        {"acls": [{"name: c"}, {"name": "d"}]},
    ]

    The usecase is adjusting YAML data
    in a list of resources that has to be compared to the API response as a whole
    as opposed to comparing the individual resources
    (which is not possible due to lack of names in the API
    to correlate individual resources with the YAML counterparts).
    """

    # TODO Allow property to be a path like prop1.prop2 when that becomes needed.

    if isinstance(data, list):
        return [unflatten_dicts_in_property(i, prop, add_key) for i in data]

    return {
        k: unflatten_dicts(v, add_key) if k == prop else v
        for k, v in data.items()
    }

def get_list_item_by_key(l, key, value):
    """
    Return the first element of l that has the given key with the given value.

    >>> get_list_item_by_key([
        {"networkName": "a", "data": "a_data"},
        {"networkName": "b", "data": "b_data"},
    ], "networkName", "a")
    {"networkName": "a", "data": "a_data"}

    The usecase is e.g. extracting data for a particular network
    from the response of an organization-level endpoint.
    """

    try:
        return next((item for item in l if item.get(key) == value))
    except (StopIteration, AttributeError):
        raise Exception(f"Dict with {key} == {value} is not found in list {l}")

def _get_switch_stack_id(stacks, name):
    for s in stacks:
        if s["id"] == name:
            return s["name"]
    raise Exception("switch stack "+name+" not found")

def _fix_switch_stacks(stp, stacks):
    logger.info(stp)
    logger.info(stacks)
    return [
        {
            "stacks": [_get_switch_stack_id(stacks, j) for j in i.get("stacks", [])] if i.get("stacks", None) is not None else None,
            "switches": i.get("switches", None),
            "stpPriority": i["stpPriority"],
            "switchProfiles": i.get("switchProfiles", None)
        } for i in stp
    ]

class FileLock:
    """Implements a file-based lock using flock(2).
    The lock file is saved in directory dir with name lock_name.
    dir is the current directory by default.
    """

    def __init__(self, lock_name, dir="."):
        self.lock_file = open(os.path.join(dir, lock_name), "w")

    def acquire(self, blocking=True):
        """Acquire the lock.
        If the lock is not already acquired, return None.  If the lock is
        acquired and blocking is True, block until the lock is released.  If
        the lock is acquired and blocking is False, raise an IOError.
        """
        ops = fcntl.LOCK_EX
        if not blocking:
            ops |= fcntl.LOCK_NB
        fcntl.flock(self.lock_file, ops)

    def release(self):
        """Release the lock. Return None even if lock not currently acquired"""
        fcntl.flock(self.lock_file, fcntl.LOCK_UN)

def _delete_cache():
    # Note: this doesn't handle locking,
    #       but that's fine since this should only be used
    #       with Pabot's "Run Setup Only Once" in the top-level Robot suite setup.
    if os.path.exists(CACHE_FILE):
        os.remove(CACHE_FILE)
    if os.path.exists(LOCK_FILE):
        os.remove(LOCK_FILE)
    logger.info("Cleared Meraki API response cache")

def _get_request_caching(session, url):
    if os.path.exists(CACHE_FILE):
        lock = FileLock(LOCK_FILE)
        lock.acquire()
        with open(CACHE_FILE, "r") as f:
            contents = f.read()
            cache = json.loads(contents)
            if url in cache:
                lock.release()
                logger.info(f"Returning url {url} result from cache: {cache[url]}")
                return cache[url]
        lock.release()
    throttle_request()
    r = request(session, "GET", url)
    lock = FileLock(LOCK_FILE)
    lock.acquire()
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE, "r") as f:
            contents = f.read()
            cache = json.loads(contents)
    else:
        cache = {}
    rjson = r.json()
    cache[url] = rjson
    with open(CACHE_FILE, "w") as f:
        f.write(json.dumps(cache))
    lock.release()
    logger.info(f"Returning url {url} result from a fresh request: {rjson}")
    return rjson

def _get_resource_id(resource, possible_id_props):
    for id_prop in possible_id_props:
        if id_prop in resource:
            return str(resource[id_prop])
    raise Exception("could not find id by possible ids:" + json.dumps(resource) +" "+json.dumps(possible_id_props))

special_res_names = {
    "switch/routing/multicast/rendezvousPoints": "interfaceIp",
    "earlyAccess/features/optIns": "shortName",
}

def _get_child_data(session, api_path, url_acc, resource_names, id_props):
    url_acc += "/"+api_path[0]
    resources = _get_request_caching(session, url_acc.strip("/"))
    if len(api_path) == 1:
        return resources
    logger.info(f"getting child data {api_path[0]}")
    res_id = special_res_names.get(api_path[0], "name")
    for r in resources:
        print(r)
        if r[res_id] == resource_names[0]:
            return _get_child_data(session, api_path[1:], url_acc+"/"+_get_resource_id(r, id_props), resource_names[1:], id_props)
    raise Exception("could not find resource by name")

def _set_suite_var(var, data):
    try:
        BuiltIn().set_suite_variable(f"${{{var}}}", data)
    except:
        pass

def _fix_devices_serials(session, obj, org_id):
    logger.info(f"obj {obj} org_id {org_id}")
    devices_map = {d["serial"]: d["name"] for d in _get_request_caching(session, f"{API_BASE}/organizations/{org_id}/devices")}
    obj["device"] = devices_map[obj["serial"]]
    return obj

def get_meraki_data(url, resource_names, suite_variable):
    resource_names = eval(resource_names)
    data = _get_meraki_data(url, resource_names)
    _set_suite_var(suite_variable, data)
    return data

def _get_meraki_data(url, resource_names):
    session = request_session()
    possible_ids = _possible_id_props_from_url(url)
    api_path = [p.strip("/") for p in re.split(API_PATH_ID_REGEX, url)]
    org_resource = False
    if api_path[0] == "organizations":
        api_path = api_path[1:]
        org_resource = True
    orgs = _get_request_caching(session, API_BASE+"/organizations")
    org_id = None
    for org in orgs:
        if org["name"] == resource_names[0]:
            org_id = org["id"]
    if org_id is None:
        raise Exception(f"Could not find organization named {resource_names[0]} in {orgs}")
    if org_resource:
        print(api_path, resource_names)
        return _get_child_data(session, api_path, f"{API_BASE}/organizations/{org_id}", resource_names[1:], possible_ids)
    top_resource_id_name = "id"
    if api_path[0] == "devices":
        top_resource_id_name = "serial"
    top_resources = _get_request_caching(session, f"{API_BASE}/organizations/{org_id}/{api_path[0]}")
    top_resource_id = None
    for t in top_resources:
        if t["name"] == resource_names[1]:
            top_resource_id = t[top_resource_id_name]
    url_acc = f"{API_BASE}/{api_path[0]}/{top_resource_id}"
    child_data = _get_child_data(session, api_path[1:], url_acc, resource_names[2:], possible_ids)
    logger.info(f"get {url}")
    if url == "/networks/{networkId}/switch/stp":
        stacks = _get_request_caching(session, f"https://api.meraki.com/api/v1/networks/{top_resource_id}/switch/stacks")
        new_stp_bridge_priority = _fix_switch_stacks(child_data["stpBridgePriority"], stacks)
        child_data["stpBridgePriority"] = new_stp_bridge_priority
    if url == "/networks/{networkId}/wireless/alternateManagementInterface":
        child_data["accessPoints"] = [_fix_devices_serials(session, x, org_id) for x in child_data["accessPoints"]]
    if url == "/networks/{networkId}/switch/linkAggregations":
        for agg in child_data:
            for p in agg['switchPorts']:
                _fix_devices_serials(session, p, org_id)
    if url == "/networks/{networkId}/appliance/ports":
        for p in child_data:
            p["port_id"] = p["number"]
    return child_data

def _possible_id_props_from_url(url):
    return [x.strip("{}") for x in re.findall(API_PATH_ID_REGEX, url)+["id", "groupId"]][1:]

def validate_per_ssid_settings(all_ssids, my_ssid):
    ssids_map = {d["name"].lower() : d for _, d in all_ssids.items()}
    return validate_subset(ssids_map[my_ssid["ssid_name"].lower()], {k : v for k, v in my_ssid.items() if k != "ssid_name"})

def validate_appliance_per_ssid_settings(api_data, my_data, ssids):
    ssids_numbers = {s["name"].lower() : s["number"] for s in ssids}
    logger.info("ssids_numbers")
    logger.info(ssids_numbers)
    per_ssid_settings = {str(ssids_numbers[s["ssid_name"]]) : {k : v for k, v in s.items() if k != "ssid_name"} for s in my_data}
    logger.info("per_ssid_settings")
    logger.info(per_ssid_settings)
    return validate_subset(api_data, per_ssid_settings)

def _map_application_id_to_api(type_value_dict):
    new_type_value_dict = type_value_dict.copy()
    if type_value_dict.get("type") in ("application", "applicationCategory"):
        new_type_value_dict["value"] = {"id": type_value_dict["value"]}
    return new_type_value_dict

def _map_country_id_to_api(type_value_dict):
    new_type_value_dict = type_value_dict.copy()
    if type_value_dict.get("type") in ("blockedCountries", "allowedCountries"):
        new_type_value_dict["value"] = type_value_dict["value_countries"]
        del new_type_value_dict["value_countries"]
    return new_type_value_dict

def _map_at_path(data, path, func):
    if isinstance(data, list):
        return [_map_at_path(item, path, func) for item in data]

    if path == "":
        return func(data)

    if not isinstance(data, dict):
        # Nothing at path, so nothing to change - return data as is.
        return data

    steps = path.split(".")
    next_step, further_steps = steps[0], steps[1:]
    further_path = ".".join(further_steps)

    new_data = data.copy()
    if next_step in data:
        new_data[next_step] = _map_at_path(new_data[next_step], further_path, func)
    return new_data

def map_application_ids_to_api(data, path=""):
    """
    Adjust the data from YAML to match the API format like the provider does:
    https://github.com/CiscoDevNet/terraform-provider-meraki/blob/5e28e94fb9feaddb7e0e20cceaf848cc565b6ab2/internal/provider/model_meraki_appliance_l7_firewall_rules.go#L74-L81
    """

    return _map_at_path(data, path, _map_application_id_to_api)

def map_country_ids_to_api(data, path=""):
    """
    Adjust the data from YAML to match the API format like the provider does:
    https://github.com/CiscoDevNet/terraform-provider-meraki/blob/5e28e94fb9feaddb7e0e20cceaf848cc565b6ab2/internal/provider/model_meraki_appliance_l7_firewall_rules.go#L82-L86
    """

    return _map_at_path(data, path, _map_country_id_to_api)

def map_names_to_ids(data, url, parent_names, path="", name_prop="", id_prop=""):
    """
    Convert names to IDs at path
    by fetching url (like "Get Meraki Data    <url>    <parent_names, name>").
    If name_prop is not "", take names from <path>.<name_prop>.
    If id_prop is not "", put names at <path>.<id_prop>, replacing <path>.<name_prop> if any.

    >>> map_names_to_ids(["netascode-network-01"], "/networks/{networkId}", "['Dev-WB']")
    ['L_4005951868546057359']

    >>> map_names_to_ids(
        [
            {
                "performance_class": {
                    "custom_performance_class_name": "Radius",
                    "type": "custom",
                },
            },
        ],
        "/networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}",
        "['Dev-WB', 'netascode-network-01']",
        path="performance_class",
        name_prop="custom_performance_class_name",
        id_prop="custom_performance_class_id")
    [
        {
            "performance_class": {
                "custom_performance_class_id": "4005951868546056226",
                "type": "custom",
            },
        },
    ]

    """

    parent_names = eval(parent_names)
    return _map_at_path(data, path, lambda data: _map_name_to_id(data, url, parent_names, name_prop, id_prop))

def _map_name_to_id(data, url, parent_names, name_prop, id_prop):
    if name_prop != "":
        name = data.get(name_prop)
        if name is None:
            return data
    else:
        name = data

    resource = _get_meraki_data(url, parent_names + [name])
    resource_id_props = _possible_id_props_from_url(url)
    id = _get_resource_id(resource, resource_id_props)

    if id_prop != "":
        if not isinstance(data, dict):
            data = {}
        new_data = data.copy()
        if name_prop != "":
            new_data.pop(name_prop, None)
        new_data[id_prop] = id
        return new_data
    else:
        return id

def rename_property(data, old_name, new_name, path=""):
    """
    If data[old_name] exists at path, rename it to data[new_name].

    >>> rename_property(
        [
            {'ipv4_address': '1.2.3.4', 'trusted_server_name': 's1'},
            {'ipv4_address': '1.2.3.4', 'trusted_server_name': 's2'},
        ],
        "ipv4_address",
        "ipv4")
    [
        {'ipv4': '1.2.3.4', 'trusted_server_name': 's1'},
        {'ipv4': '1.2.3.4', 'trusted_server_name': 's2'},
    ]
    """

    return _map_at_path(data, path, lambda data: _rename_property(data, old_name, new_name))

def _rename_property(data, old_name, new_name):
    new_data = data.copy()
    if old_name in new_data:
        new_data[new_name] = new_data[old_name]
        del new_data[old_name]

    return new_data

def clear_meraki_api_cache():
    _delete_cache()
