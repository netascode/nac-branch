# 🌐 data/templates-network-related.nac.yaml File

The **data/templates-network-related.nac.yaml** file in the `data/` folder defines comprehensive network configuration templates for branch infrastructure.  Templates are applied at the network level and configure device behaviors across the deployment.

The **data/templates-network-related.nac.yaml** file defines the following templates:

- Fundamental network configuration for site creation - defined in the **nw_setup** template.
- Tagging at the network level - defined in the **nw_tags** template.
- Network-wide management plane settings for monitoring and access control - defined in the **nw_management** template.
- Group policy settings returned from wireless 802.1x authentication - defined in the **group_policies** template 

## 📋 nw_setup Configuration Template

The **nw_setup** template defines fundamental network configuration including product types and elements for site creation, such as timezones and descriptions.  

The template defines the following variables:

  - **time_zone**: String - Time zone the branch is located within
  - **network_notes**: String - Notes relevant to the network

The **nw_setup** template establishes the base network configuration by:

- Enabling specific Meraki product types (appliance, switch, wireless, cellularGateway)
- Setting location-specific time zone for accurate logging and scheduling
- Adding operational notes for site-specific requirements or constraints
- Applying metadata tags for categorization, reporting, and search operations


## 📋 nw_tags Configuration Template

The **nw_tags** template references the **nw_tags.yaml.tftpl** file which holds the configuration for the support of a variable number of network tags.  

The **nw_tags** template defines a variable **network_tags**, which contains a list of one or more tags to be applied to the network to which the template is applied.  A usage example is shown in the **Unified Branch 2** network within the **data/pods_variables.nac.yaml** file, where the tags "small_branch" and "ubac" are applied to the **Unified Branch 2** network. 

To apply the IPsec tunnels defined for Cisco Secure Access / SSE integration within the **third_party_vpn_peeers** section of the **data/org_global.nac.yaml** add the tag "SSE" to the list of tags for the network.

## 📋 nw_management Configuration Template

The **nw_management** template configures network-wide management plane settings for monitoring and access control.

The template defines the following variables:

  - **syslog_server**: String - IP address of the corporate syslog server
  - **syslog_port**: Integer - Port for the corporate syslog server
  - **netflow_server**: String - IP address of the corporate NetFlow server
  - **netflow_port**: Integer - Port for the corporate NetFlow server
  - **local_page_username**: String - Username for local status page authentication, specified as an environmental variable
  - **local_page_password**: String - Password for local status page authentication, specified as an environmental variable
  - **snmp_username**: String - Username for SNMP authentication, specified as an environmental variable
  - **snmp_password**: String - Password for SNMP authentication, specified as an environmental variable

The **nw_management** template establishes management configurations:
- Local and remote status page access for troubleshooting the device directly
- SNMPv3 with user-based authentication for secure monitoring of MIBs
- Centralized syslog collection for compliance and troubleshooting
- Named VLAN support for dynamic RADIUS-based VLAN assignment

Security Considerations:
- Credentials use !env to reference environment variables (never hardcode)
- SNMPv3 provides encryption and authentication vs SNMPv2 community strings
- Local status page should use strong credentials and the password is a minimum 12 chars

Integration Requirements:
- Syslog server must be reachable from management VLAN
- SNMP collector must support SNMPv3 with matching credentials, default encryption is DES
- Named VLANs require coordination with RADIUS server configuration

## 📋 group_policies Configuration Template

The **group_policies** template configures the group policies that are returned by the Radius server through the Filter-Id attribute during 802.1x authentication for wired and wireless devices. Each group policy returns the VLAN ID override applicable to the VLAN to which the client is assigned.

The template defines the following variables:

  - **data_vlan_group_policy**: String - Name of the group policy which returns the VLAN ID (VLAN 10) for the Data VLAN
  - **voice_vlan_group_policy**: String - Name of the group policy which returns the VLAN ID (VLAN 20) for the Voice VLAN
  - **iot_vlan_group_policy**: String - Name of the group policy which returns the VLAN ID (VLAN 30) for the IoT VLAN

The YAML code defines three group policies, with the policy group name and the VLAN assignment defined as variables. Since no other group policy parameters are configured, they do not appear within the YAML code. Please refer to the following URL for a full definition of available parameters within group policies:

https://netascode.cisco.com/docs/data_models/meraki/networks/group_policies/

Additional group policies with their respective VLAN ID assignments can be added to the YAML code as needed for additional VLANs.

## 📋 webhooks Configuration Template

The **webhooks** template configures the sending of near real-time alerts from the Meraki Dashboard delivered to Splunk via HTTP Event Collector (HEC).  Please see the [Cisco Meraki Add-on for Splunk](https://documentation.meraki.com/Platform_Management/Dashboard_Administration/Operate_and_Maintain/How-Tos/Cisco_Meraki_Add-on_for_Splunk) for the pre-requisits and requirements for implementing webhooks integration with Splunk.

The template defines the following variables:

  - **splunk_template_name**: String - Descriptive name for the Splunk template
  - **splunk_hec_token**: String - Contains the HEC token generated within Splunk. See the Webhook Alerts section of document referenced above for instructions on generating the HEC token
  - **splunk_server_name**: String - Descriptive name for the Splunk server to which the webhook alerts will be sent
  - **url**: String - URL for sending the webhook alerts to the Splunk server
