class Rule:
    id = "101"
    description = "Admin name must always include 'admin' (case-insensitive)"
    severity = "HIGH"
    paths = ["meraki"]  # optional, ensures rule is considered

    @staticmethod
    def is_valid_admin_name(name):
        return bool(name and "admin" in name.lower())

    @classmethod
    def match(cls, data, schema=None):
        print("Rule 110_must_admin.match() called")
        results = []

        meraki = data.get("meraki", {})
        domains = meraki.get("domains", [])

        if not domains:
            results.append("meraki.domains - No domains found")
            return results

        for domain in domains:
            domain_name = domain.get("name", "<unnamed domain>")
            for key, value in domain.items():
                if isinstance(value, list):
                    for item in value:
                        if isinstance(item, dict) and "name" in item:
                            admin_name = item["name"]
                            print(f"Checking admin_name={admin_name} in domain={domain_name} key={key}")
                            if not cls.is_valid_admin_name(admin_name):
                                results.append(
                                    f"meraki.domains - Invalid admin name: {admin_name} in domain {domain_name} (key '{key}')"
                                )

        return results