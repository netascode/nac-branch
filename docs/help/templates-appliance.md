# 🌐 templates-appliance.nac.yaml File

The **templates-appliance.nac.yaml** file in the `data/` folder defines the following templates which provide the following set of Unified Branch services applicable to the secure router (security appliance):

- Appliance (secure router) settings - defined in the **app_settings** template
- Hub settings - defined in the **app_hub** template 
- Spoke AutoVPN configuration - defined in the **app_spoke** template
- Port configuration - defined in the **app_ports** template
- VLAN configuration - defined in the **app_vlans** template
- Fixed IP assignment configuration for the Infra VLAN - defined in the **fixed_ip_assignments** template
- Second secure router configuration for medium and large branches - defined in the **warm_spare** template
- Firewall configuration - defined in the **app_fw** template
- Content filtering - defined in the **app_content** template
- Intrusion prevention - defined in the **app_intrusion** template
- Malware prevention - defined in the **app_mal** template

Variables within the templates use ${variable_name} syntax and sensitive data uses !env for environment variables.

## 📋 app_settings Configuration Template

The **app_settings** template configures the secure router for routed mode operation, tracks clients by MAC address, and enables dynamic DNS for accessing the security appliance.

The template defines the following variables:

- None

## 📋 app_hub Configuration Template

The **app_hub** template configures the network to which the template is applied as a hub and advertises the VLAN 10 (Data), VLAN 20 (Voice), VLAN 30 (Iot), VLAN 40 (PCI), and VLAN 999 (Infra) subnets across the VPN to the cloud.  Note, this template may be unused as the hub name is imported in the current release.

The template defines the following variables:

  - **vlan10_subnet**: String - CIDR for the VLAN 10 (Data) subnet
  - **vlan20_subnet**: String - CIDR for the VLAN 20 (Voice) subnet
  - **vlan30_subnet**: String - CIDR for the VLAN 30 (IoT) subnet
  - **vlan40_subnet**: String - CIDR for the VLAN 40 (PCI) subnet
  - **vlan999_subnet**: String - CIDR for the VLAN 999 (Infra) subnet

Values must be assigned to these variables when the template is assigned to a network within the **pods_variables.nac.yaml** file.

## 📋 app_spoke Configuration Template

The **app_spoke** template references the **spoke.yaml.tftpl** file which holds the actual configuration for the spoke configuration.  The **app_spoke** template configures the branch network to which the template is applied as a spoke with a variable number of hub routers. 

The template defines the following variables:

  - **hub_network_name**: String - Name of the hub network
  - **hub_default_route**: Boolean - Determines whether the hub is a default route for the spoke
  - **vlan10_subnet**: String - CIDR for the VLAN 10 (Data) subnet
  - **vlan20_subnet**: String - CIDR for the VLAN 20 (Voice) subnet
  - **vlan30_subnet**: String - CIDR for the VLAN 30 (IoT) subnet
  - **vlan40_subnet**: String - CIDR for the VLAN 40 (PCI) subnet
  - **vlan50_subnet**: String - CIDR for the VLAN 50 (Guest) subnet
  - **vlan999_subnet**: String - CIDR for the VLAN 999 (Infra) subnet

Advertises the VLAN 10 (Data), VLAN 20 (Voice), VLAN 30 (IoT), VLAN 40 (PCI), and VLAN 999 (infra) subnets across the VPN to the cloud. VLAN 50 (Guest) is not advertised across the VPN. The default VLAN (VLAN 1) is automatically configured by the secure router and does not appear within the YAML.

Note that for Unified Branch Phase 2, the **use_default_route** paramater for the hub has been changed from true to a variable called **hub_default_route**. This is to accomodate SSE / Cisco Secure Access Cloud integration at the branch.  When SSE / Cisco Secure Access Cloud integration is enabled, the default route for all Internet bound traffic that does not have a specific exclusion will be sent to the Cisco Secure Access Cloud data centers.  Therefore, the **use_default_route** parameter must be set to **false** when enabling SSE / Cisco Secure Access Cloud integration.  Otherwise, the **use_default_route** parameter must be set to **true** as was done for Unified Branch Phase 1.


## 📋 app_ports Configuration Template

The **app_ports** template configures the LAN ports of the secure router(s) for the small, medium, and large branch designs.

The template defines the following variables:

  - **peer_sgt_capable**: Boolean - Setting which allows SGT tags to be passed through AutoVPN tunnels
  - **adaptive_policy_group**: Integer - Sets the Adaptive Policy Group (SGT) of untagged traffic across the trunk

The **app_ports** template configures and enables LAN ports 5, 6, 13, & 14 as trunks to the branch switch. The ports shown in the configuration within the YAML file are specific to the MX85 secure router. Use either ports 5 - 6 (RJ-45) or ports 13 & 14 (SFP) for redundant connectivity. For MX95/105 secure routers the SFP LAN ports are ports 9 & 10. If you are using an MX67 with two WAN ports, the LAN port range is ports 3 - 5. If you are using an MX68 the LAN port range is ports 3 - 12, with ports 11 & 12 supporting POE+. Depending upon the secure router model you are deploying, you will need to change the port_id_ranges you wish to enable and configure as trunks.

Allows VLANs 1, 10, 20, 30, 40, 50, and 999. Native VLAN 1 on the trunk serves to allow devices downstream of the secure router to initially get IP addresses and communicate with the Meraki cloud. Upon receiving their configurations, devices downstream of the secure router are configured with VLAN 999 (infra) as their manangement VLAN. VLANs 10, 20, 30, 40, and 50 correspond to Data, Voice, IoT, PCI, and Guest VLANs.

Set unused LAN ports to be shut down on the secure routers. For the MX85 secure router shown in the example, this corresponds to ports 7 - 12 along with either 5, 6 or 13, 14 depending on whether you use (RJ-45) or (SFP) connections between the secure router and the switch / switch stack.


## 📋 app_vlans Configuration Template

The **app_vlans** template configures the SVI defintions (VLANs) and their IP address assignments for the secure router(s) for the small, medium, and large branch designs.

The template defines the following variables:

  - **vlan10_subnet**: String - CIDR for the VLAN 10 (Data) subnet
  - **vlan10_appliance_ip**: String - IP address of the secure router interface for VLAN 10
  - **vlan20_subnet**: String - CIDR for the VLAN 20 (Voice) subnet
  - **vlan20_appliance_ip**: String - IP address of the secure router interface for VLAN 20
  - **vlan30_subnet**: String - CIDR for the VLAN 30 (IoT) subnet
  - **vlan30_appliance_ip**: String - IP address of the secure router interface for VLAN 30
  - **vlan40_subnet**: String - CIDR for the VLAN 40 (PCI) subnet
  - **vlan40_appliance_ip**: String - IP address of the secure router interface for VLAN 40
  - **vlan50_subnet**: String - CIDR for the VLAN 50 (Guest) subnet
  - **vlan50_appliance_ip**: String - IP address of the secure router interface for VLAN 50
  - **vlan999_subnet**: String - CIDR for the VLAN 999 (Infra) subnet
  - **vlan999_appliance_ip** - IP address of the secure router interface for VLAN 999
  - **corp_dhcp_server1**: String - IP address of first corporate DHCP server
  - **corp_dhcp_server2**: String - IP address of second corporate DHCP server
  - **dns_server_1**: String - IP address of first corporate DNS server
  - **dns_server_2**: String - IP address of second corporate DNS server

The **app_vlans** template hardcodes the configuration for 6 VLANs - VLAN 10 (Data), VLAN 20 (Voice), VLAN 30 (IoT), VLAN 40 (PCI), VLAN 50 (Guest), and VLAN 999 (infra). For each VLAN, the IPv4 subnet and address of the security appliance are defined as variables. The VLAN names are hardcoded. IPv6 is commented out for each VLAN, as it is not supported with branch designs with dual routers for Unified Branch Phase 2.

For VLANs 10 (Data), 20 (Voice), 30 (IoT), and 40 (PCI) the configuration specifies relaying DHCP back to centralized corporate DHCP servers, configured as variables. 

For VLANs 1 (Default), 50 (Guest), and 999 (Infra), separate DHCP server instances are configured within each VLAN to assign IP addresses to client devices for the VLAN, with the following example configuration:

Mandatory IP address assignment for VLAN 50 (Guest)

DNS server specified as openDNS for VLAN 50. User defined DNS servers for VLAN 999 (Infra)

DHCP lease time of 1 day for VLANs 50 and 999.  No DHCP boot options specified.

## 📋 app_fixed_ip_assignment Configuration Template

The **app_fixed_ip_assignments** template references the **fixed_ip_assignments.yaml.tftpl** file which holds the actual configuration for the fixed IP assignments configuration.  The **fixed_ip_assignments** template configures a variable number of management IP address assignments on the Infra VLAN (VLAN 999) for switch and AP devices downstream of the secure routers within the branch network to which the template is applied.

The template defines the following variables:

Under **fixed_ip_assignments**:
- **name**: String - Radius Server IP address
- **ip**: Integer - Radius Server port
- **mac**: String - Radius Server secret

Fixed IP address assignments for VLAN 999 corresponding to the management interfaces of the switches and APs. This is to ensure network devices have a consistent IP address for sourcing syslog, NetFlow, snmp, Radius, etc. For each switch and AP in the network, ensure there is an entry which includes the name, IP address, and MAC address of the device.


## 📋 warm_spare Configuration Template

The **warm_spare** configuration template defines the uplink mode, virtual IP addresses, and name if the warm spare secure router for medium and large branch designs. The template hardcodes the **uplink_mode** to be **virtual**.

The template defines the following variables:

  - **virtual_ip1**: String - Virtual IP address for the WAN 1 interface shared by both secure routers within the branch
  - **virtual_ip2**: String - Virtual IP address for the WAN 2 interface shared by both secure routers within the branch
  - **appliance_02_name**: String - Name of the warm spare secure router for the small or medium branch


## 📋 app_fw Configuration Template

The **app_fw** template hardcodes firewall rules on the secure router(s) for small, medium, and large branches. The rules are configured as examples which match the configuretion and IP addressing within the Unified Branch CVD. Network administrators should modify the firewall rules based on the security policy and requirements of their individual organizations.

The template defines the following variables:

  - None

### 🔍 Outbound Layer 3 Firewall Rules Section

The outbound Layer 3 firewall rules section configures network-wide outbound firewall rules.  These rules apply to traffic leaving the secure routers within the network to which the template is applied, that is not sent across AutoVPN tunnels.  In other words, it applies to inter-VLAN traffic within the branch, and to traffic sent directly to the Internet (DIA access).  Note that due to current limitations, for Unified Branch Phase 2, policy object and policy object group names are not used in the policy rules.  Instead, the IP addresses are hardcoded into the file.  However, the notes below explain the rules based on policy objects and policy object groups, as discussed in the Unified Branch CVD.

- The "Local Print Access" rule allows all devices in the Data VLAN (VLAN 10), access to the IP addresses of the printers on the shared services / IoT VLAN for the given branch.  All Data VLANs across branches are assumed to use the IP addressing of 10.10.x.0/24, where x is the specific branch.  The same concept holds for the Voice, IoT, PCI, and Infra VLANs.  From a policy object and policy object group perspective, this rule allows traffic from the **Data Subnet** policy object to **Branch 1 Printers** policy object group.  Since this is a stateful rule, the return traffic is allowed through as well.

- The "Default (VLAN 1) Access" rule denies all access from the Default VLAN (VLAN 1) to the Data, Voice, IoT, PCI, Guest, and Infra VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **Default Subnet** policy object to the **Data Subnet**, **Voice Subnet**, **IoT Subnet**, **PCI Subnet**, **Guest Subnet**, and **Infra Subnet** policy objects.

- The "Data Access" rule denies all access from the Data VLAN (VLAN 10) to the Default (VLAN 1), Voice, IoT, PCI, Guest, and Infra VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **Data Subnet** policy object to the **Default Subnet**, **Voice Subnet**, **IoT Subnet**, **PCI Subnet**, **Guest Subnet**, and **Infra Subnet** policy objects.

- The "Voice Access" rule denies all access from the Voice VLAN (VLAN 20) to the Default (VLAN 1), Data, IoT, PCI, Guest, and Infra VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **Voice Subnet** policy object to the **Default Subnet**, **Data Subnet**, **IoT Subnet**, **PCI Subnet**, **Guest Subnet**, and **Infra Subnet** policy objects.

- The "IoT Access" rule denies all access from the IoT VLAN (VLAN 30) to the Default (VLAN 1), Data, Voice, PCI, Guest, and Infra VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **IoT Subnet** policy object to the **Default Subnet**, **Data Subnet**, **Voice Subnet**, **PCI Subnet**, **Guest Subnet**, and **Infra Subnet** policy objects.

- The "PCI Access" rule denies all access from the PCI VLAN (VLAN 40) to the Default (VLAN 1), Data, Voice, IoT, Guest, and Infra VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **PCI Subnet** policy object to the **Default Subnet**, **Data Subnet**, **Voice Subnet**, **IoT Subnet**, **Guest Subnet**, and **Infra Subnet** policy objects.

- The "Guest Access" rule denies all access from the Guest VLAN (VLAN 50) to the Default (VLAN 1), Data, Voice, IoT, PCI, and Infra VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **Guest Subnet** policy object to the **Default Subnet**, **Data Subnet**, **Voice Subnet**, **IoT Subnet**, **PCI Subnet**, and **Infra Subnet** policy objects.

- The "Infra Access" rule denies all access from the Infra VLAN (VLAN 999) to the Default (VLAN 1), Data, Voice, IoT, PCI, and Guest VLANs within the branch.  From a policy object and policy object group perspective, this rule denies traffic from the **Infra Subnet** policy object to the **Default Subnet**, **Data Subnet**, **Voice Subnet**, **IoT Subnet**, **PCI Subnet**, and **Guest Subnet** policy objects.

- The "Allow DIA" rule allows direct Internet access for all devices on the default VLAN (VLAN 1), the Infra VLAN (VLAN 999), the Data VLAN (VLAN 10), and Guest VLAN (VLAN 50).  From a policy object and policy object group perspective, this rule allows traffic from the **INFRA Subnet**, **Data Subnet**, **Guest Subnet**, and  **Default_Subnet** to any destination. Since this is a stateful rule, the return traffic is allowed through as well.
  
- The "Deny All" rule denies all other connectivity. 
  
There is an implicit default rule allowing all connectivity which is configured automatically by the dashboard as the last rule, and is not shown here.  

Note that the use of VLANs within the L3 firewall rules is not allowed when deploying redundant secure routers in a warm spare (active/standby) configuration.

### 🔍 Services Available / Blocked From the Outside Interface of the Secure Router Section

  - ICMP services allowed
  - Web services blocked
  - SNMP services blocked

### 🔍 Outbound Layer 7 Firewall Rules Section

- No Outbound Layer 7 firewall rules are configured for the Unified Branch CVD design.
  

## 📋 app_content Configuration Template

The **app_content** template enables content filtering on the security appliance. Entries under **allowed_url_patterns**, **blocked_url_patterns**, and **blocked_url_categories** are examples only. Network administrators should configure content filtering rules based on the security policy and requirements of their individual organizations.

The template defines the following variables:

  - None

List entries under allowed_url_patterns are specific URLs excluded from content filtering and therefore allowed.  List entries under blocked_url_patterns are automatically blocked. List entries under blocked_url_categories consist of categories of URLs automatically blocked. (Note that URL category must be specified by ID currently. Work to translate the IDs into user-friendly names is ongoing.)

## 📋 app_intrusion Configuration Template

The **app_intrusion** template enables intrusion prevention on the security appliance and hardcodes a balanced ruleset, which is a compromise between performance and security. Note that no exclusion rules have been configured.

The template defines the following variables:

  - None

## 📋 app_mal Configuration Template

The **app_mal** template enables advanced malware protection on the security appliance. The hardcoded **allowed_urls** list ("www.cisco.com and *.meraki.com") are excluded from malware scanning. The hardcoded allowed_files list contains files previously seen across the organization which were blocked. Currently these are specified as SHA-256 hash strings. Work to translate the hash strings into user-friendly names is ongoing.

The template defines the following variables:

  - None