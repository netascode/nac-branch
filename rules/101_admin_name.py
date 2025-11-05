class Rule:
    id = "101"
    description = "Admin name must always include 'admin' (case-insensitive)"
    severity = "HIGH"
    paths = ["meraki"]  # ensures the rule is considered by the framework

    @staticmethod
    def is_valid_admin_name(name):
        """Check if admin name contains 'admin' (case-insensitive)."""
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

            # Only check the known admin keys
            for admin_key in ["administrator", "admins"]:
                admins = domain.get(admin_key, [])
                if not admins:
                    continue  # no admins under this key, skip
                for admin in admins:
                    admin_name = admin.get("name")
                    if not admin_name:
                        results.append(
                            f"meraki.domains - Admin missing name in domain {domain_name} (key '{admin_key}')"
                        )
                    elif not cls.is_valid_admin_name(admin_name):
                        results.append(
                            f"meraki.domains - Invalid admin name: {admin_name} in domain {domain_name} (key '{admin_key}', must contain 'admin')"
                        )
                    else:
                        print(f"Checking admin_name={admin_name} in domain={domain_name} key={admin_key}")

        return results
