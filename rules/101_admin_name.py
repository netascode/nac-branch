class Rule:
    id = "101"
    description = "Verify all admins start with 'admin'"
    severity = "HIGH"

    paths = [
        "meraki.domains.organizations.admins.name",
    ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path):
        results = []
        # Safely get domains
        domains = inventory.get("meraki", {}).get("domains", [])
        for domain in domains:
            orgs = domain.get("organizations", [])
            for org in orgs:
                admins = org.get("admins", [])
                for admin in admins:
                    name = admin.get("name")
                    if not isinstance(name, str) or not name.lower().startswith("admin"):
                        results.append(f"{full_path} - invalid admin name: {name}")
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            results.extend(cls.match_path(inventory, path, path))
        return results


# ----------------------------
# Test Example
# ----------------------------
inventory = {
    "meraki": {
        "domains": [
            {
                "name": "domain1",
                "organizations": [
                    {
                        "name": "org1",
                        "admins": [
                            {"name": "admin1"},   # OK
                            {"name": "Admin2"},   # OK (case-insensitive)
                            {"name": "root1"},    # FAIL
                            {"name": "userX"},    # FAIL
                        ]
                    },
                    {
                        "name": "org2",
                        "admins": [
                            {"name": "admin3"},   # OK
                            {"name": "superadmin"} # OK
                        ]
                    }
                ]
            }
        ]
    }
}

print(Rule.match(inventory))
