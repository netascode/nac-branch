# utils.py
import re
import time
import json
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
import fcntl
import os
from meraki_request import (
    request_session,
    request,
)

# Constants
API_PATH_ID_REGEX = r"{[a-zA-Z]*}"
API_BASE = os.environ.get("MERAKI_BASE_URL", "https://api.meraki.com/api/v1")
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
    text = re.sub(r"(?<!^)(?=[A-Z])", "_", text).lower()
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
        return [
            filter_by_whitelist(elem, whitelist, path=path + f"[{repr(i)}]")
            for i, elem in enumerate(x)
        ]
    ret = {}
    top_level = list(filter(lambda x: "." not in x, whitelist))
    for t in top_level:
        try:
            ret[t] = x.get(t, None)
        except AttributeError as e:
            raise Exception(
                f"filter_by_whitelist(path={path}): Failed to get {repr(t)} from {repr(x)}: {e}"
            )
    not_top_level = list(filter(lambda x: "." in x, whitelist))
    first_level = set([i.split(".")[0] for i in not_top_level])
    for f in first_level:
        if f not in x:
            continue
        child_fields = [
            ".".join(i.split(".")[1:])
            for i in filter(lambda j: j.startswith(f), whitelist)
        ]
        ret[f] = filter_by_whitelist(x[f], child_fields, path=path + f"[{repr(f)}]")
    return ret


abbreviations = {
    "dest": "destination",
    "dst": "destination",
    "src": "source",
    "org": "organization",
    "ip_ver": "ip_version",
}


def unabbreviate_string(s):
    ret = [s]
    for k, v in abbreviations.items():
        if k + "_" in s:
            ret.append(s.replace(k + "_", v + "_"))
        if "_" + k in s:
            ret.append(s.replace("_" + k, "_" + v))
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
    logger.info(
        f"Actual superset ({superset_path}): {json.dumps(superset, sort_keys=True, indent=4)}"
    )
    logger.info(
        f"Expected subset ({subset_path}): {json.dumps(subset, sort_keys=True, indent=4)}"
    )
    if not isinstance(superset, type(subset)) and not isinstance(
        subset, type(superset)
    ):
        return False
    if isinstance(subset, dict):
        for k, v in subset.items():
            if k == "secret" or k == "password":
                continue
            child_superset_path = f"{superset_path}.{k}"
            child_subset_path = f"{subset_path}.{k}"
            if not _validate_subset(
                superset.get(k, None), v, child_superset_path, child_subset_path
            ):
                return False
        return True
    elif isinstance(subset, list):
        if len(subset) != len(superset):
            return False
        for subset_i, subset_item in enumerate(subset):
            found = False
            for superset_i, superset_item in enumerate(superset):
                child_superset_path = f"{superset_path}[{superset_i}]"
                child_subset_path = f"{subset_path}[{subset_i}]"
                if _validate_subset(
                    superset_item, subset_item, child_superset_path, child_subset_path
                ):
                    found = True
                    break
            if not found:
                return False
        return True
    else:
        return superset == subset or (is_empty(subset) and is_empty(superset))


def validate_subset(superset, subset, whitelist=[]):
    """
    Check that YAML data (subset) is a subset of the API response (superset), recursively,
    applying some heuristics (unabbreviate_superset(), skipping password fields).
    For lists, the lists must be equal size and elements should pass validate_subset().
    For dicts, only the key-value pairs from subset must pass validate_subset() -
    extra pairs in superset are ignored.
    """

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

    return {k: unflatten_dicts(v, add_key) if k == prop else v for k, v in data.items()}


def unflatten_dict(data, add_key, path=""):
    """
    Wrap the value at the given path in a single-item dict keyed by add_key.

    Unlike unflatten_dicts / unflatten_dicts_in_property, this puts the whole
    value (list or scalar) under add_key as-is rather than wrapping each list
    item. path may be a dotted path (e.g. "svis.ipv4.nameservers") to reach a
    nested value; lists encountered along the path are iterated.

    >>> unflatten_dict(
    ...     {"svis": {"ipv4": {"nameservers": ["8.8.8.8", "8.8.4.4"]}}},
    ...     "addresses",
    ...     path="svis.ipv4.nameservers",
    ... )
    {'svis': {'ipv4': {'nameservers': {'addresses': ['8.8.8.8', '8.8.4.4']}}}}

    The usecase is adjusting YAML data flattened in the .nac.yaml schema
    (e.g. nameservers: [...]) to the API's nested shape (nameservers:
    {addresses: [...]}) for comparison with the API response.
    """

    return _map_at_path(data, path, lambda data: {add_key: data})


def get_list_item_by_key(lst, key, value):
    """
    Return the first element of lst that has the given key with the given value.

    >>> get_list_item_by_key([
        {"networkName": "a", "data": "a_data"},
        {"networkName": "b", "data": "b_data"},
    ], "networkName", "a")
    {"networkName": "a", "data": "a_data"}

    The usecase is e.g. extracting data for a particular network
    from the response of an organization-level endpoint.
    """

    try:
        return next((item for item in lst if item.get(key) == value))
    except (StopIteration, AttributeError):
        raise Exception(f"Dict with {key} == {value} is not found in list {lst}")


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
    raise Exception(
        "could not find id by possible ids:"
        + json.dumps(resource)
        + " "
        + json.dumps(possible_id_props)
    )


special_res_names = {
    "switch/routing/multicast/rendezvousPoints": "interfaceIp",
    "earlyAccess/features/optIns": "shortName",
}


def _get_child_data(session, api_path, url_acc, resource_names, id_props):
    url_acc += "/" + api_path[0]
    resources = _get_request_caching(session, url_acc.strip("/"))
    if len(api_path) == 1:
        return resources
    logger.info(f"getting child data {api_path[0]}")
    res_id = special_res_names.get(api_path[0], "name")
    for r in resources:
        print(r)
        if r[res_id] == resource_names[0]:
            return _get_child_data(
                session,
                api_path[1:],
                url_acc + "/" + _get_resource_id(r, id_props),
                resource_names[1:],
                id_props,
            )
    raise Exception("could not find resource by name")


def _set_suite_var(var, data):
    try:
        BuiltIn().set_suite_variable(f"${{{var}}}", data)
    except Exception:
        pass


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
    orgs = _get_request_caching(session, API_BASE + "/organizations")
    org_id = None
    for org in orgs:
        if org["name"] == resource_names[0]:
            org_id = org["id"]
    if org_id is None:
        raise Exception(
            f"Could not find organization named {resource_names[0]} in {orgs}"
        )
    if org_resource:
        print(api_path, resource_names)
        return _get_child_data(
            session,
            api_path,
            f"{API_BASE}/organizations/{org_id}",
            resource_names[1:],
            possible_ids,
        )
    top_resource_id_name = "id"
    if api_path[0] == "devices":
        top_resource_id_name = "serial"
    top_resources = _get_request_caching(
        session, f"{API_BASE}/organizations/{org_id}/{api_path[0]}"
    )
    top_resource_id = None
    for t in top_resources:
        if t["name"] == resource_names[1]:
            top_resource_id = t[top_resource_id_name]
    url_acc = f"{API_BASE}/{api_path[0]}/{top_resource_id}"
    child_data = _get_child_data(
        session, api_path[1:], url_acc, resource_names[2:], possible_ids
    )
    logger.info(f"get {url}")
    return child_data


def _possible_id_props_from_url(url):
    result = [
        x.strip("{}") for x in re.findall(API_PATH_ID_REGEX, url) + ["id", "groupId"]
    ]
    for problematic_parent_id in ["organizationId", "networkId"]:
        try:
            result.remove(problematic_parent_id)
        except ValueError:
            pass
    return result


def validate_per_ssid_settings(all_ssids, my_ssid):
    ssids_map = {d["name"].lower(): d for _, d in all_ssids.items()}
    return validate_subset(
        ssids_map[my_ssid["ssid_name"].lower()],
        {k: v for k, v in my_ssid.items() if k != "ssid_name"},
    )


def validate_appliance_per_ssid_settings(api_data, my_data, ssids):
    ssids_numbers = {s["name"].lower(): s["number"] for s in ssids}
    logger.info("ssids_numbers")
    logger.info(ssids_numbers)
    per_ssid_settings = {
        str(ssids_numbers[s["ssid_name"]]): {
            k: v for k, v in s.items() if k != "ssid_name"
        }
        for s in my_data
    }
    logger.info("per_ssid_settings")
    logger.info(per_ssid_settings)
    return validate_subset(api_data, per_ssid_settings)


def filter_api_site_to_site_vpn_subnets(actual, expected):
    """
    Filter out "false" entries from the (actual) API response that don't have a matching local_subnet in (expected) YAML data.
    """

    return _map_at_path(
        actual,
        "subnets",
        lambda data: _filter_api_site_to_site_vpn_subnets(data, expected),
    )


def _filter_api_site_to_site_vpn_subnets(actual, expected):
    filtered_actual = []
    for actual_entry in actual:
        has_match_in_expected = False
        for expected_entry in expected:
            if expected_entry.get("local_subnet") == actual_entry.get("localSubnet"):
                has_match_in_expected = True
                break

        if not actual_entry.get("useVpn", False) and not has_match_in_expected:
            continue
        filtered_actual.append(actual_entry)

    return filtered_actual


def group_switch_stp_by_bridge_priority(switch_stp, path=""):
    return _map_at_path(switch_stp, path, _group_switch_stp_by_bridge_priority)


def _group_switch_stp_by_bridge_priority(stp_bridge_priorities):
    priority_map = {}

    for priority_entry in stp_bridge_priorities:
        priority = priority_entry.get("stpPriority", priority_entry.get("stp_priority"))
        grouped_priority_entry = priority_map.setdefault(priority, {})

        grouped_priority_entry["priority"] = priority
        grouped_priority_entry.setdefault("stacks", []).extend(
            priority_entry.get("stacks") or []
        )
        profiles = (
            priority_entry.get("switchProfiles")
            or priority_entry.get("switch_profiles")
            or []
        )
        grouped_priority_entry.setdefault("switch_profiles", []).extend(profiles)
        grouped_priority_entry.setdefault("switches", []).extend(
            priority_entry.get("switches") or []
        )

    priority_map.pop(32768, None)

    return list(priority_map.values())


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


def _map_items_at_path(data, path, func):
    """
    Return data with the items nested under path
    replaced with the result of calling func on them.
    The path can include lists, in which case every list item is processed,
    including the data under the path itself.

    If the list at path itself needs to be modified (instead of just its individual items),
    use _map_at_path() instead.

    >>> _map_items_at_path(
        {
            "first_level": [
                {
                    "second_level": [1, 2]
                },
                {
                    "second_level": [3, 4]
                }
            ]
        },
        "first_level.second_level",
        lambda data: data * 10)
    {
        "first_level": [
            {
                "second_level": [10, 20]
            },
            {
                "second_level": [30, 40]
            }
        ]
    }
    """

    def wrapper_func(data):
        if isinstance(data, list):
            return [func(item) for item in data]
        else:
            return func(data)

    return _map_at_path(data, path, wrapper_func)


def _map_at_path(data, path, func):
    """
    Return data with the data nested under path
    replaced with the result of calling func on it.
    The path can include lists, in which case every list item is processed,
    except the data under the path itself - that is passed to the function directly.

    See filter_out_items_by_key() for example usage.
    """

    if path == "":
        return func(data)

    if isinstance(data, list):
        return [_map_at_path(item, path, func) for item in data]

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

    return _map_items_at_path(data, path, _map_application_id_to_api)


def map_country_ids_to_api(data, path=""):
    """
    Adjust the data from YAML to match the API format like the provider does:
    https://github.com/CiscoDevNet/terraform-provider-meraki/blob/5e28e94fb9feaddb7e0e20cceaf848cc565b6ab2/internal/provider/model_meraki_appliance_l7_firewall_rules.go#L82-L86
    """

    return _map_items_at_path(data, path, _map_country_id_to_api)


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
    return _map_items_at_path(
        data,
        path,
        lambda data: _map_name_to_id(data, url, parent_names, name_prop, id_prop),
    )


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

    return _map_items_at_path(
        data, path, lambda data: _rename_property(data, old_name, new_name)
    )


def _rename_property(data, old_name, new_name):
    new_data = data.copy()
    if old_name in new_data:
        new_data[new_name] = new_data[old_name]
        del new_data[old_name]

    return new_data


def filter_out_items_by_key(data, key, values, path=""):
    """
    Return data with items at path where key equals any of the values removed.

    >>> filter_out_built_in_items(
        {
            'rules': [
                {
                    'comment': 'Block Bad Traffic',
                    'policy': 'deny',
                    'protocol': 'udp',
                    'srcPort': '1433',
                    'srcCidr': 'Any',
                    'destPort': '1433',
                    'destCidr': 'Any',
                    'syslogEnabled': False,
                },
                {
                    'comment': 'Block SSH',
                    'policy': 'deny',
                    'protocol': 'tcp',
                    'srcPort': '22',
                    'srcCidr': 'Any',
                    'destPort': '22',
                    'destCidr': 'Any',
                    'syslogEnabled': False,
                },
                {
                    'comment': 'Default rule',
                    'policy': 'allow',
                    'protocol': 'Any',
                    'srcPort': 'Any',
                    'srcCidr': 'Any',
                    'destPort': 'Any',
                    'destCidr': 'Any',
                    'syslogEnabled': False,
                },
            ],
        },
        "comment",
        ["Default rule"],
        path="rules")
    {
        'rules': [
            {
                'comment': 'Block Bad Traffic',
                'policy': 'deny',
                'protocol': 'udp',
                'srcPort': '1433',
                'srcCidr': 'Any',
                'destPort': '1433',
                'destCidr': 'Any',
                'syslogEnabled': False,
            },
            {
                'comment': 'Block SSH',
                'policy': 'deny',
                'protocol': 'tcp',
                'srcPort': '22',
                'srcCidr': 'Any',
                'destPort': '22',
                'destCidr': 'Any',
                'syslogEnabled': False,
            },
        ],
    }
    """

    return _map_at_path(
        data, path, lambda data: _filter_out_items_by_key(data, key, values)
    )


def _filter_out_items_by_key(data, key, values):
    return [item for item in data if item.get(key) not in values]


def map_fixed_ip_assignments_to_api(fixed_ip_list):
    """
    Transform fixed_ip_assignments from list format (YAML) to dict format (API).

    YAML format: [{name, ip, mac}, ...]
    API format: {'mac': {name, ip}, ...}

    >>> transform_fixed_ip_assignments_to_api_format([
        {'name': 'Device 1', 'ip': '192.168.1.10', 'mac': '00:11:22:33:44:55'},
        {'name': 'Device 2', 'ip': '192.168.1.11', 'mac': '00:11:22:33:44:56'}
    ])
    {
        '00:11:22:33:44:55': {'name': 'Device 1', 'ip': '192.168.1.10'},
        '00:11:22:33:44:56': {'name': 'Device 2', 'ip': '192.168.1.11'}
    }
    """
    if not isinstance(fixed_ip_list, list):
        return fixed_ip_list

    result = {}
    for item in fixed_ip_list:
        if not isinstance(item, dict):
            continue
        mac = item.get("mac")
        if mac:
            result[mac] = {k: v for k, v in item.items() if k != "mac"}
    return result


def _format_vlan_token(v, allow_ipv4=True):
    """
    Format a VLAN entry from YAML into the Meraki VLAN CIDR token.
      - vlan_id + ipv4_offset  => VLAN(<id>).<offset>   (only when allow_ipv4=True)
      - vlan_id + ipv6_offset  => VLAN(<id>)<offset>
      - vlan_id only           => VLAN(<id>).*
    """
    vlan_id = v.get("vlan_id")
    ipv4_offset = v.get("ipv4_offset")
    ipv6_offset = v.get("ipv6_offset")
    if allow_ipv4 and ipv4_offset is not None:
        return f"VLAN({vlan_id}).{ipv4_offset}"
    if ipv6_offset is not None:
        return f"VLAN({vlan_id}){ipv6_offset}"
    return f"VLAN({vlan_id}).*"


def _lookup_policy_object_id(org_name, name):
    """Fetch the numeric ID for a named policy object."""
    resource = _get_meraki_data(
        "/organizations/{organizationId}/policyObjects/{policyObjectId}",
        [org_name, name],
    )
    return resource["id"]


def _lookup_policy_object_group_id(org_name, name):
    """Fetch the numeric ID for a named policy object group."""
    resource = _get_meraki_data(
        "/organizations/{organizationId}/policyObjects/groups/{policyObjectGroupId}",
        [org_name, name],
    )
    return resource["id"]


def assemble_firewall_rules(rules, org_name, allow_ipv4_vlans=True):
    """
    Convert raw YAML firewall rules into a list of dicts that match the Meraki
    API response format, so they can be passed to Validate Subset.

    For each rule:
      - source_cidr / destination_cidr are assembled by concatenating:
          * the explicit source_cidr / destination_cidr value (if present)
          * OBJ(<id>) for each source_policy_objects / destination_policy_objects name
          * GRP(<id>) for each source_policy_object_groups / destination_policy_object_groups name
          * VLAN tokens for each source_vlans / destination_vlans entry
      - The new YAML-only fields are removed from the returned dict so that
        Validate Subset only sees keys the API knows about.

    allow_ipv4_vlans controls whether ipv4_offset is honoured (False for inbound rules).
    """
    assembled = []
    for rule in rules:
        r = {k: v for k, v in rule.items()}

        for side in ("source", "destination"):
            cidr_key = f"{side}_cidr"
            objects_key = f"{side}_policy_objects"
            groups_key = f"{side}_policy_object_groups"
            vlans_key = f"{side}_vlans"

            tokens = []

            # 1. Explicit CIDR
            if cidr_key in r and r[cidr_key] is not None:
                tokens.append(str(r[cidr_key]))

            # 2. Policy objects => OBJ(<id>)
            for name in r.pop(objects_key, None) or []:
                obj_id = _lookup_policy_object_id(org_name, name)
                tokens.append(f"OBJ({obj_id})")

            # 3. Policy object groups => GRP(<id>)
            for name in r.pop(groups_key, None) or []:
                grp_id = _lookup_policy_object_group_id(org_name, name)
                tokens.append(f"GRP({grp_id})")

            # 4. VLAN tokens
            for v in r.pop(vlans_key, None) or []:
                tokens.append(_format_vlan_token(v, allow_ipv4=allow_ipv4_vlans))

            # Write back assembled cidr (only if there is anything to write)
            if tokens:
                r[cidr_key] = ",".join(tokens)

        assembled.append(r)
    return assembled


def clear_meraki_api_cache():
    _delete_cache()
