# Network as Code for Unified Branch – `nac-branch`

## 📘 Introduction

This initial release of **Unified Branch – Branch as Code** (referred to as **Release 1, Early Availability**) introduces the provisioning of branch network infrastructure—**security appliances**, **switches**, and **Wi-Fi access points**—holistically using **Network as Code (NAC)** concepts, practices, and procedures.

➡️ Check the [Unified Branch - Branch as Code Design Guide: Release 1 - Early Availability](docs/Readme.md) to learn more about the deployment model supported.

➡️ The Branch as Code Design Guide is available here: **\[ADD LINK]**

---

## 🧰 Requirements

To make use of this repository, you will need:

* ✅ A **Meraki API Key**
* ✅ **Hardware Serial Numbers** for the setup (as described in the [Network Design Section](#)) **\[ADD LINK]**
* ✅ Network Variables (e.g. **Network Name**, **Hostnames**, **IP Addressing Schema**, etc.)

---

## 📁 File Structure

```
nac-branch/
├── data/
├── images/
├── workspaces/
├── .gitignore
├── Readme.md
└── main.tf
```

### `data/`

Contains YAML configuration files used for [Network as Code](https://netascode.cisco.com). This includes organization-wide settings, templates, and variable definitions.

Contents:

```
data/
├── org_global.nac.yaml
├── pods_variables.nac.yaml
├── templates-appliance-related.nac.yaml
├── templates-inventory-related.nac.yaml
└── templates-network-related.nac.yaml
```

* **`org_global.nac.yaml`**
  Defines organization-level settings such as login security, policy objects, SNMP settings, etc.


* **`pods_variables.nac.yaml`**
  Contains branch-specific variables like **Branch Name**, **Hostnames**, **IP addressing**, etc.


* **`templates-*-related.nac.yaml`**
  Define reusable templates for **appliance**, **inventory**, and **network** components.


  🔸 Wireless configuration is part of the **network-related** templates.


---

### `images/`

Stores reference diagrams and visuals for documentation and dashboard use.

---

### `workspaces/`

Contains environment-specific configuration files and is used for **branch template resolution**.

The Terraform module invoked in this folder will:

* Load templates and variable values from `/data`
* Merge them into a single file: `merged_configuration.nac.yaml`

---

### `.gitignore`

Defines files and directories to be excluded from version control (e.g., `.terraform/`, logs, cache files).

---

### `README.md`

This file. Provides an overview of the project and usage instructions.

---

### `main.tf`

Primary **Terraform configuration file**. It defines infrastructure resources and modules for the NAC deployment.

---

## 🚀 How to Use This Repository


### 1. Clone or Fork the Repository

```bash
git clone <your_repo_url>
cd nac-branch
```

### 2. Export Your Meraki API Key

```bash
export MERAKI_API_KEY=ABC1234
```

### 3. Edit Your Configuration Files

Navigate to the `data/` folder and update the following:

* `pods_variables.nac.yaml` – set your desired branch variables
* `org_global.nac.yaml` – set your org-level configuration

Sample configuration is included for reference.

### 4. Run Workspace Terraform

```bash
cd workspaces
terraform init
terraform apply
```

✅ This generates a `merged_configuration.nac.yaml` in the `workspaces/` folder.

💡 **Tip**: If you're using **VSCode**, install the [YAML Language Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) extension to catch YAML syntax errors early.

### 5. Run Root-Level Terraform

```bash
cd ..
terraform init
terraform plan
```

⚠️ The included `main.tf` assumes **local tfstate storage**. If you are using **GitLab CI**, **Terraform Cloud**, or another backend, update the backend block accordingly.

### 6. Apply the Configuration

```bash
terraform apply
```

🎉 This will push the configuration to the **Meraki Dashboard**.

---

Let us know if you encounter any issues or have suggestions to improve this workflow by raising PR/Issue within the repository.
