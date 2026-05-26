# 🌐 pods_variables.nac.yaml File

The **pods_variables.nac.yaml** YAML file in the `data/` folder references the organization named with the name specified as an environmental variable as a data source. It further creates spoke networks representing small, medium, and large branches, under the organization:

The **pods_variables.nac.yaml** file defines no templates. For each branch network created (small, medium,  or large) add the name of the templates to be included within the branch, and fill in the required variables which are defined in the referenced templates within the following YAML and TFTPL files in the `data/` folder:

- **templates-appliance.nac.yaml**
- **templates-internet-policies.nac.yaml**
- **templates-inventory.nac.yaml**
- **templates-network-related.nac.yaml**
- **templates-switch.nac.yaml**
- **templates-wan-connectivity.nac.yaml**
- **templates-wan-ts.nac.yaml**
- **templates-wan-uplinks.nac.yaml**
- **templates-wan-vpn-exclusions.nac.yaml**
- **templates-wireless.nac.yaml**
- **fixed_ip_assignments.yaml.tftpl**
- **nw_tags.yaml.tftpl**
- **spoke.yaml.tftpl**
- **switch_access_policy.yaml.tftpl**
- **switch_link_aggregations.yaml.tftpl**
- **switch_stacks.yaml.tftpl**
- **switch_stp.yaml.tftpl**
- **wireless_radius.yaml.tftpl**

## 🛠️ How to Use These Templates

1. SELECT A TEMPLATE:
   Choose the appropriate template from templates-xxx-related.nac.yaml based on your configuration needs.

2. REFERENCE THE TEMPLATE:
   In your network configuration, reference the template name:
   networks:
     - name: "Your-Network"
       templates:
         - name: wan_dhcp_dhcp  # Or whichever template you need

3. DEFINE VARIABLES:
   Create a pod with the necessary variables as shown in these examples Only include the variables required by your selected template

4. APPLY CONFIGURATION:
   The terraform provider will merge the template with your variables to create the final configuration

## 🧩 Variables and Templates Used

The following are the templates defined within each YAML file in the `data/` folder:

 From **templates-appliance.nac.yaml**
 - **app_settings**
 - **app_hub**
 - **app_spoke**
 - **app_ports**
 - **app_vlans**
 - **app_fixed_ip_assignments**
 - **app_warm_spare**
 - **app_fw**
 - **app_content**
 - **app_intrusion**
 - **app_mal**

 From **templates-internet-policies.nac.yaml**
 - **internet_policies**

 From **templates-inventory.nac.yaml**
 - **small_branch_inventory**
 - **medium_branch_inventory**
 - **large_branch_inventory**

 From **templates-network-related.nac.yaml**
 - **nw_setup**
 - **nw_tags**
 - **nw_management**
 - **group_policies**
 - **webhooks**

 From **templates-switch.nac.yaml**
 - **switch_access_policy**
 - **switch_stack**
 - **switch_stp**
 - **switch_link_aggregations**
 - **switch**

 From **templates-wan-ts.nac.yaml**
 - **app_ts**

 From **templates-wan-uplinks.nac.yaml**
 - **medium_wan_dhcpx2**
 - **wan_dhcp_dhcp**
 - **wan_static_dhcp**
 - **wan_dhcp_static**
 - **wan_static_static**
 - **wan_pppoe_dhcp**
 - **wan_dhcp_pppoe**
 - **wan_pppoe_pppoe**
 - **wan_vlan_vlan**
 - **wan_vlan_static_dhcp**
 - **wan_ipv4_dhcp_dhcp**
 - **wan_ipv4_static_dhcp**
 - **wan_p2p_31**
 - **wan_enterprise_vlan**

From **templates-wan-vpn-exclusions.nac.yaml**
 - **app_vpn_exclusions**

 From **templates-wireless.nac.yaml**
 - **wireless_radius**
 - **wireless**

 Note: **templates-wan-connectivity.nac.yaml** is present in the `data/` folder but defines no templates.

The following are the variables defined within each template in the `data/` folder.

 From the templates within the **templates-wan-uplinks.nac.yaml** file:

 APPLIANCE:
 - **appliance_01_serial**: String - Device serial number (format: QXXX-XXXX-XXXX)
 - **appliance_01_name**: String - Descriptive device name

 WAN1 CONFIGURATION:
 - **wan1_enabled**: Boolean - Enable/disable WAN1 (default: true)
 - **wan1_vlan_enabled**: Boolean - Enable VLAN tagging (default: false)
 - **wan1_vlan_id**: Integer - VLAN ID (1-4094)
 - **wan1_pppoe_enabled**: Boolean - Enable PPPoE (default: false)
 - **wan1_pppoe_auth_enabled**: Boolean - Enable PPPoE authentication (default: true)
 - **wan1_pppoe_username**: String - PPPoE username
 - **wan1_pppoe_password**: String - PPPoE password (5-64 characters)
 - **wan1_ipv4_mode**: String - "dynamic" or "static"
 - **wan1_ipv4_address**: String - IPv4 address with CIDR (e.g., "192.168.1.10/24")
 - **wan1_ipv4_gateway**: String - IPv4 gateway address
 - **wan1_ipv4_dns**: List - DNS servers (e.g., ["8.8.8.8", "8.8.4.4"])
 - **wan1_ipv6_address**: String - IPv6 address with prefix (e.g., "2001:db8::10/64")
 - **wan1_ipv6_gateway**: String - IPv6 gateway address
 - **wan1_ipv6_dns**: List - IPv6 DNS servers

 WAN2 CONFIGURATION:
 - **wan2_enabled**: Boolean - Enable/disable WAN2 (default: true)
 - **wan2_vlan_enabled**: Boolean - Enable VLAN tagging (default: false)
 - **wan2_vlan_id**: Integer - VLAN ID (1-4094)
 - **wan2_pppoe_enabled**: Boolean - Enable PPPoE (default: false)
 - **wan2_pppoe_auth_enabled**: Boolean - Enable PPPoE authentication (default: true)
 - **wan2_pppoe_username**: String - PPPoE username
 - **wan2_pppoe_password**: String - PPPoE password (5-64 characters)
 - **wan2_ipv4_mode**: String - "dynamic" or "static"
 - **wan2_ipv4_address**: String - IPv4 address with CIDR
 - **wan2_ipv4_gateway**: String - IPv4 gateway address
 - **wan2_ipv4_dns**: List - DNS servers
 - **wan2_ipv6_address**: String - IPv6 address with prefix
 - **wan2_ipv6_gateway**: String - IPv6 gateway address
 - **wan2_ipv6_dns**: List - IPv6 DNS servers


 From **app_settings** template:
 - None

 From **app_hub** template:
 - **vlan10_subnet**: String - IPv4 address with CIDR of VLAN 10 (Data)
 - **vlan20_subnet**: String - IPv4 address with CIDR of VLAN 20 (Voice)
 - **vlan30_subnet**: String - IPv4 address with CIDR of VLAN 30 (IoT)
 - **vlan999_subnet**: String - IPv4 address with CIDR of VLAN 999 (Infra)

 From **app_spoke** template:
 *Renders `data/spoke.yaml.tftpl`.*
 - **hubs**: List of objects (each with `name` and `default_route`) - Hub networks the spoke connects to
 - **vlan10_subnet**: String - IPv4 address with CIDR of VLAN 10 (Data)
 - **vlan20_subnet**: String - IPv4 address with CIDR of VLAN 20 (Voice)
 - **vlan30_subnet**: String - IPv4 address with CIDR of VLAN 30 (IoT)
 - **vlan40_subnet**: String - IPv4 address with CIDR of VLAN 40 (PCI)
 - **vlan50_subnet**: String - IPv4 address with CIDR of VLAN 50 (Guest)
 - **vlan999_subnet**: String - IPv4 address with CIDR of VLAN 999 (Infra)

 From **app_ports** template:
 - None

 From **app_vlans** template:
 - **vlan10_subnet**: String - IPv4 address with CIDR of VLAN 10 (Data)
 - **vlan10_appliance_ip**: String - IPv4 address of Secure router for VLAN 10 (Data)
 - **vlan20_subnet**: String - IPv4 address with CIDR of VLAN 20 (Voice)
 - **vlan20_appliance_ip**: String - IPv4 address of Secure router for VLAN 20 (Voice)
 - **vlan30_subnet**: String - IPv4 address with CIDR of VLAN 30 (IoT)
 - **vlan30_appliance_ip**: String - IPv4 address of Secure router for VLAN 30 (IoT)
 - **vlan40_subnet**: String - IPv4 address with CIDR of VLAN 40 (PCI)
 - **vlan40_appliance_ip**: String - IPv4 address of Secure router for VLAN 40 (PCI)
 - **vlan50_subnet**: String - IPv4 address with CIDR of VLAN 50 (Guest)
 - **vlan50_appliance_ip**: String - IPv4 address of Secure router for VLAN 50 (Guest)
 - **vlan999_subnet**: String - IPv4 address with CIDR of VLAN 999 (Infra)
 - **vlan999_appliance_ip**: String - IPv4 address of Secure router for VLAN 999 (Infra)
 - **corp_dhcp_server1**: String - IPv4 address of remote DHCP Server 1
 - **corp_dhcp_server2**: String - IPv4 address of remote DHCP Server 2
 - **dns_server_1**: String - IPv4 address of primary DNS server
 - **dns_server_2**: String - IPv4 address of secondary DNS server

 From **app_fixed_ip_assignments** template:
 *Renders `data/fixed_ip_assignments.yaml.tftpl`.*
 - **fixed_ip_assignments**: List of objects (each with `name`, `ip`, `mac`) - Reserved IPs on VLAN 999 (Infra) for switches/APs

 From **app_warm_spare** template:
 - **virtual_ip1**: String - IPv4 address shared by first WAN interface in warm spare configuration
 - **virtual_ip2**: String - IPv4 address shared by second WAN interface in warm spare configuration
 - **appliance_02_name**: String - Name of the warm spare secure router for the small or medium branch

 From **app_fw** template:
 - None

 From **app_content** template:
 - None

 From **app_intrusion** template:
 - None

 From **app_mal** template:
 - None

 From **internet_policies** template:
 - **vlan10_subnet**: String - IPv4 address with CIDR of VLAN 10 (Data)
 - **vlan20_subnet**: String - IPv4 address with CIDR of VLAN 20 (Voice)

 From **small_branch_inventory** template:
 - **appliance_01_name**: String - Descriptive device name for Secure router
 - **appliance_01_serial**: String - Device serial number for Secure router
 - **lat**: String - Latitude coordinates for devices in the network
 - **lng**: String - Longitude coordinates for devices in the network
 - **address**: String - Location address for devices in the network
 - **access_switch_01_name**: String - Descriptive device name for first switch
 - **access_switch_01_serial**: String - Device serial number for first switch
 - **access_switch_02_name**: String - Descriptive device name for second switch
 - **access_switch_02_serial**: String - Device serial number for second switch
 - **ap_01_name**: String - Descriptive device name for first AP
 - **ap_01_serial**: String - Device serial number for first AP
 - **ap_02_name**: String - Descriptive device name for second AP
 - **ap_02_serial**: String - Device serial number for second AP

 From **medium_branch_inventory** template:
 - **appliance_01_name**: String - Descriptive device name for Secure router
 - **appliance_01_serial**: String - Device serial number for Secure router
 - **appliance_02_name**: String - Descriptive device name for Secure router
 - **appliance_02_serial**: String - Device serial number for Secure router
 - **lat**: String - Latitude coordinates for devices in the network
 - **lng**: String - Longitude coordinates for devices in the network
 - **address**: String - Location address for devices in the network
 - **access_switch_01_name**: String - Descriptive device name for first switch
 - **access_switch_01_serial**: String - Device serial number for first switch
 - **access_switch_02_name**: String - Descriptive device name for second switch
 - **access_switch_02_serial**: String - Device serial number for second switch
 - **ap_01_name**: String - Descriptive device name for first AP
 - **ap_01_serial**: String - Device serial number for first AP
 - **ap_02_name**: String - Descriptive device name for second AP
 - **ap_02_serial**: String - Device serial number for second AP

 From **large_branch_inventory** template:
 - **appliance_01_name**: String - Descriptive device name for Secure router
 - **appliance_01_serial**: String - Device serial number for Secure router
 - **appliance_02_name**: String - Descriptive device name for Secure router
 - **appliance_02_serial**: String - Device serial number for Secure router
 - **lat**: String - Latitude coordinates for devices in the network
 - **lng**: String - Longitude coordinates for devices in the network
 - **address**: String - Location address for devices in the network
 - **dist_switch_01_name**: String - Descriptive device name for first distribution switch
 - **dist_switch_01_serial**: String - Device serial number for first distribution switch
 - **dist_switch_02_name**: String - Descriptive device name for second distribution switch
 - **dist_switch_02_serial**: String - Device serial number for second distribution switch
 - **access_switch_01_name**: String - Descriptive device name for first switch
 - **access_switch_01_serial**: String - Device serial number for first switch
 - **access_switch_02_name**: String - Descriptive device name for second switch
 - **access_switch_02_serial**: String - Device serial number for second switch
 - **ap_01_name**: String - Descriptive device name for first AP
 - **ap_01_serial**: String - Device serial number for first AP
 - **ap_02_name**: String - Descriptive device name for second AP
 - **ap_02_serial**: String - Device serial number for second AP

 From **nw_setup** template:
 - **time_zone**: String - Time Zone (ex. America/Los_Angeles)
 - **network_notes**: String

 From **nw_tags** template:
 *Renders `data/nw_tags.yaml.tftpl`.*
 - **network_tags**: List of strings - Tags applied to the network

 From **nw_management** template:
 - **syslog_server**: String - IPv4 address of remote syslog server
 - **syslog_port**: Integer (min=1, max=65535) - Syslog server port
 - **netflow_server**: String - IPv4 address of remote NetFlow server
 - **netflow_port**: Integer (min=1, max=65535) - NetFlow server port

 From **group_policies** template:
 - **data_vlan_group_policy**: String - Group policy name for device assignment to VLAN 10 (Data)
 - **voice_vlan_group_policy**: String - Group policy name for device assignment to VLAN 20 (Voice)
 - **iot_vlan_group_policy**: String - Group policy name for device assignment to VLAN 30 (IoT)

 From **webhooks** template:
 - **splunk_template_name**: String - Name of the Splunk webhook payload template
 - **splunk_hec_token**: String - Splunk HTTP Event Collector authorization token
 - **splunk_server_name**: String - Display name of the Splunk webhook server
 - **splunk_webhooks_server_url**: String - URL of the Splunk webhook endpoint

 From **switch_access_policy** template:
 *Renders `data/switch_access_policy.yaml.tftpl`.*
 - **radius_servers**: List of objects (each with `host`, `port`, `secret`) - RADIUS authentication servers
 - **radius_accounting_servers**: List of objects (each with `host`, `port`, `secret`) - RADIUS accounting servers

 From **switch_stack** template:
 *Renders `data/switch_stacks.yaml.tftpl`.*
 - **stacks**: List of objects (each with stack name and member serials) - Switch stack definitions

 From **switch_stp** template:
 *Renders `data/switch_stp.yaml.tftpl`.*
 - **stp_bridge_priority**: List of objects (each with `switches` and `stp_priority`) - Per-switch STP bridge priority

 From **switch_link_aggregations** template:
 *Renders `data/switch_link_aggregations.yaml.tftpl`.*
 - **link_aggregations**: List of objects (each describing an LACP/static bundle) - Link aggregation group definitions

 From **switch** template:
 - **switch_mtu_size**: Integer (min=1, max=9578) - MTU size of the switch

 From **app_ts** template:
 - **wan_limit_up**: Integer (min=0, max=1000000) - Secure router upstream per-client rate-limit (0 = unlimited)
 - **wan_limit_down**: Integer (min=0, max=1000000) - Secure router downstream per-client rate-limit (0 = unlimited)
 - **wan1_limit_up**: Integer (min=0, max=1000000) - Secure router WAN1 interface upstream rate-limit (0 = unlimited)
 - **wan1_limit_down**: Integer (min=0, max=1000000) - Secure router WAN1 interface downstream rate-limit (0 = unlimited)
 - **wan2_limit_up**: Integer (min=0, max=1000000) - Secure router WAN2 interface upstream rate-limit (0 = unlimited)
 - **wan2_limit_down**: Integer (min=0, max=1000000) - Secure router WAN2 interface downstream rate-limit (0 = unlimited)

 From **wireless_radius** template:
 *Renders `data/wireless_radius.yaml.tftpl`.*
 - **data_wireless_ssid_name**: String - Descriptive name for the SSID corresponding to employee traffic
 - **wireless_radius_servers**: List of objects (each with `host`, `port`, `secret`) - Wireless RADIUS authentication servers
 - **wireless_radius_accounting_servers**: List of objects (each with `host`, `port`, `secret`) - Wireless RADIUS accounting servers

 From **wireless** template:
 - **data_wireless_ssid_name**: String - Descriptive name for the SSID corresponding to employee traffic
 - **guest_wireless_ssid_name**: String - Descriptive name for the SSID corresponding to guest traffic
 - **data_ssid_schedules_enabled**: Boolean - Enable Data SSID unavailability schedule 
 - **guest_ssid_schedules_enabled**: Boolean - Enable Guest SSID unavailability schedule 
 - **guest_wireless_client_bw_down**: Integer (min=0, max=1000000) - Guest SSID upstream per-client rate-limit (0 = unlimited)
 - **guest_wireless_client_bw_up**: Integer (min=0, max=1000000) - Guest SSID downstream per-client rate-limit (0 = unlimited)
 - **guest_wireless_ssid_bw_down**: Integer (min=0, max=1000000) - Guest SSID upstream rate-limit (0 = unlimited)
 - **guest_wireless_ssid_bw_up**: Integer (min=0, max=1000000) - Guest SSID upstream rate-limit (0 = unlimited)
 - **guest_ssid_welcome_message**: String - Message displayed in Guest SSID pass-through splash page