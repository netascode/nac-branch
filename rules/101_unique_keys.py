class Rule:
    id = "101"
    description = "Verify unique keys"
    severity = "HIGH"

    paths = [
        "meraki.domains.name",
        "meraki.domains.organizations.name",
        "meraki.domains.organizations.networks.name",
        "meraki.domains.organizations.administrators.name",
        "meraki.domains.organizations.networks.switch_stacks.name",
        "meraki.domains.organizations.action_batches.action_batch_name",
        "meraki.domains.organizations.adaptive_policy_acls.name"
        "meraki.domains.organizations.adaptive_policy_acls.rules.name",
        "meraki.domains.organizations.networks.appliance.ports.port_id_ranges.from",
        "meraki.domains.organizations.networks.appliance.ports.port_id_ranges.to",
    ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements[:-1]):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(i, full_path, ".".join(path_elements[idx:]))
                    results.extend(r)
                return results
            if inv_element is None:
                return results
        values = []
        if isinstance(inv_element, list):
            for i in inv_element:
                if not isinstance(i, dict):
                    continue
                value = i.get(path_elements[-1])
                if isinstance(value, list):
                    values = []
                    for v in value:
                        if v not in values:
                            values.append(v)
                        else:
                            results.append(full_path + " - " + str(v))
                elif value:
                    if value not in values:
                        values.append(value)
                    else:
                        results.append(full_path + " - " + str(value))
        elif isinstance(inv_element, dict):
            list_element = inv_element.get(path_elements[-1])
            if isinstance(list_element, list):
                for value in list_element:
                    if value:
                        if value not in values:
                            values.append(value)
                        else:
                            results.append(full_path + " - " + str(value))
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            r = cls.match_path(inventory, path, path)
            results.extend(r)
        return results
