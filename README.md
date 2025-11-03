# 🌐 Network as Code for Unified Branch – Branch as Code (`nac-branch`)

This repository delivers the **Network as Code for Unified Branch – Branch as Code** capability (Release 1, November 2025).  
It automates provisioning of cloud-managed branch infrastructure — security appliances, switches, and Wi-Fi access points — using repeatable, version-controlled Terraform artifacts instead of manual dashboard configuration.

All artifacts are aligned with **Cisco Validated Designs (CVDs)** and optimized for **greenfield deployments** (new branch networks configured as VPN spokes).  
The provided code supports importing pre-configured organizations and hubs.

## 📚 More Information

- [Unified Branch – Branch as Code Design Guide](docs/Readme.md)  
- [Cisco Validated Design](https://www.cisco.com/c/en/us/solutions/design-zone/campus-branch.html)  
- [Cisco Unified Branch Solution Brief](https://www.cisco.com/c/en/us/td/docs/solutions/CVD/Campus/Unifiedbranch_solution_brief_0813v4.html)  
- [Branch as Code Documentation](https://netascode.cisco.com/docs/guides/branch/00_overview/)
- [Dashboard Device Initial Onboarding Flow and Best Practices](docs/Device_Onboarding_Flow.md)

## 🧰 Prerequisites

You will need:

1. A **Meraki API key** with configuration permissions.  
   *(Dashboard → Organization → Settings → Dashboard API access)*  
   → [API access documentation](https://documentation.meraki.com/General_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API#Enable_API_access)
2. Branch or Pod **variable data** (serial numbers, IP addressing schema, VLAN IDs, hostnames, etc.)
3. **Environment variables** for credentials and secrets.  
   Secrets may also be stored in a secret manager or Terraform variable file, depending on your policy.

🛡️ [Learn more about variables in Branch as Code](https://netascode.cisco.com/docs/guides/branch/04_fundamentals-nac-bac/#understanding-variables-used-in-branch-as-code)


## 📁 Repository Structure

```bash
nac-branch-terraform/
├── Changelog.md
├── Readme.md
├── main.tf
├── schema.yaml  🔹
├── data/
├── docs/
├── tests/        🔹
├── .rules/       🔹
└── workspaces/
```
**Legend**  
🔹 - The complete set of schema and tests is available through the **Services as Code** subscription. Custom rules that can be created and adapted for each customer.


**File and folder overview:**

- **Changelog.md** – release notes and change history  
- **Readme.md** – this document  
- **main.tf** – primary Terraform configuration defining NAC resources and modules  
- **schema.yaml** – defines the YAML data model (sections, allowed keys, types, relationships)
- **data/** – YAML configuration files for [Branch as Code](https://netascode.cisco.com/docs/guides/branch/04_fundamentals-nac-bac/#data)  
- **docs/** – reference diagrams and design documentation  
- **tests/** – example automated tests for integration with CI/CD pipelines  
- **rules/** – custom semantic rule definitions for policy enforcement  
- **workspaces/** – environment-specific configurations for **branch template resolution**

**🧩 `data/` Folder Overview**

- **org_global.nac.yaml** – organization-level baseline: login security, policy objects, SNMP, etc.  
- **pods_variables.nac.yaml** – branch-specific variables (name, hostnames, addressing, VLANs).  
  👉 *This is typically the only file you modify when deploying new branches.*  
- **templates-*.nac.yaml** – modular configuration templates segmented by technology domain. Inline documentation is included. Some templates include predefined values for common use cases but are intended to be modified to reflect the customer’s specific environment. 

> ⚠️ These are **Network as Code templates**, not Meraki configuration templates. They are **CVD-aligned** and designed to work with the [Network as Code Meraki Terraform](https://registry.terraform.io/modules/netascode/nac-meraki) modules.


## 🚀 Deployment Workflow


![Branch as Code High-Level Deployment Flow](docs/images/steps.png)


### 1. Fork the Repository

Fork this repository into your organization’s workspace.  
Avoid cloning directly from the upstream if you plan to customize.

```
# Replace <your-github-org> with your GitHub username or org
git clone https://github.com/<your-github-org>/nac-branch.git
cd nac-branch
git remote add upstream https://github.com/netascode/nac-branch.git
git fetch upstream
```

### 2. Export Required Environment Variables

Export all required environment variables before running Terraform:

```bash
# Device serial numbers
export Appliance=YOUR_APPLIANCE_SERIAL
export AP=YOUR_AP1_SERIAL
export AP2=YOUR_AP2_SERIAL
export Switch1=YOUR_SWITCH1_SERIAL
export Switch2=YOUR_SWITCH2_SERIAL

# Organization identification
export org_name="Your Meraki Org Name"
export domain="YourDomainIdentifier"

# Admin credentials
export org_admin="admin-username"
export org_admin_email="admin@example.com"

# SNMPv3 credentials
export v3_auth_pass="CHANGE_ME_AUTH"
export v3_priv_pass="CHANGE_ME_PRIV"
export snmp_username="snmpUser"
export snmp_passphrase="CHANGE_ME_SNMP"

# Local device access credentials
export local_status_page_username="statusUser"
export local_status_page_password="CHANGE_ME_STATUS"
export local_page_username="localUser"
export local_page_password="CHANGE_ME_LOCAL"

# RADIUS secrets
export radius_accounting_server1_secret="CHANGE_ME_RADIUS_ACCT"
export radius_server1_secret="CHANGE_ME_RADIUS_AUTH"

# Meraki API key (least privilege recommended)
export MERAKI_API_KEY="REPLACE_WITH_API_KEY"
```

💡 *Tip:* Use a `.env` file and source it (`source ./set_env_vars.sh`).  
Ensure `.env` is excluded via `.gitignore`. You may also integrate a secrets manager.

### 3. 🧩 Configure Your Branch Variables

Navigate to the `data/` folder and update:

- `pods_variables.nac.yaml` – define branch/pod variables (serials, VLANs, etc.)

A sample configuration is provided for reference.

### 4. 🧠 Render Templates

Render configuration templates using your defined variables.  
This step does **not** push any configuration to Meraki — it only builds the merged YAML that stays in memory.

> Note: the `workspaces/` directory is not a Terraform deployment workspace for Meraki resources; it is only used locally to render the merged YAML configuration. 

```bash
cd workspaces
terraform init
terraform apply
```

✅ Output: `merged_configuration.nac.yaml` generated in `workspaces/`.


### 5. 🔍 [Optional] Validate Configuration (`nac-validate`)

Validate the merged YAML before deployment to catch syntax or semantic issues early. 
As part of the toolkit, we can use [nac-validate](https://github.com/netascode/nac-validate/blob/main/README.md) CLI tool to perform syntactic and semantic validation of YAML files.

Install (requires Python 3.10+):

```bash
pip install nac-validate
```

Run validation:

```bash
nac-validate --non-strict ./workspaces/merged_configuration.nac.yaml
```

> The `--non-strict` flag is used here since the sample schema omits certain keys. Remove it when validating against a complete schema.

💡 *VS Code users:* install the [YAML Language Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) extension for real-time validation.

👉 Learn more about [Configuration Validation.](https://netascode.cisco.com/docs/guides/concepts/validation/)


### 6. 🗺️ Plan Terraform Deployment

Generate the Terraform plan to preview intended changes:

```bash
cd ..
terraform init
terraform plan
```

⚠️ The included configuration uses **local state**.  
For team usage, configure a **remote backend** (e.g., Terraform Cloud, GitLab CI) with state locking to prevent concurrency issues.


### 7. 🚀 Apply Configuration

Apply the configuration to push changes to the Meraki Dashboard:

```bash
terraform apply
```


### 8. ✅ [Optional] Post-Deployment Tests (`nac-test`)

Run post-change tests to confirm that the Meraki Dashboard matches the intended configuration. For this we make use of [nac-test](https://github.com/netascode/nac-test) CLI tool. 


```bash
pip install nac-test
```

Run:

```bash
nac-test -d workspaces/merged_configuration.nac.yaml -t ./tests/templates -o ./tests/results
```

Passing `nac-test` confirms configuration integrity and reproducibility.  
👉 Learn more about [Configuration Testing.](https://netascode.cisco.com/docs/guides/concepts/testing/)

## 💬 Issues & Feedback

We welcome your feedback!  
If you encounter issues or have suggestions, please open a **Issue** in this repository.

