# 🌐 templates-wireless.nac.yaml File

The **templates-wireless.nac.yaml** file in the `data/` folder defines the following templates:

- Wireless authentication - defined in the **wireless_radius** configuration template.
- Wireless configuration - defined in the **wireless** configuration template.

## 📋 wireless_radius Configuration Template

The **wireless_radius** template references the **wireless_radius.yaml.tftpl** file which holds the actual configuration for the wireless Radius policy, and allows for the support of a variable number of Radius and Radius accounting servers to be defined for the Data SSID. 

The template defines the following variables:

- **data_wireless_ssid_name**: String - Descriptive name for the SSID corresponding to employee traffic
- Under **radius_servers**:
  - **host**: String - Radius server IP address
  - **port**: Integer - Radius server port
  - **secret**: String - Radius server secret
- Under **radius_accounting_servers**:
  - **host**: String - Radius accounting server IP address
  - **port**: Integer - Radius accounting server port
  - **secret**: String - Radius accounting server secret

If multiple Radius and Radius Accounting servers are added, load-balancing is round-robin. If the Radius servers are unavailable access is denied.

## 📋 wireless Configuration Template

The **wireless** template configures various parameters under three main sections - **settings**, **rf_profiles**, and **ssids** for the access points within the network to which the template is applied. The parameters defined within this template provide an example configuration based on best-practices consistent with Cisco Validated Designs. However, as with all network deployments, the specific configuration parameters should be modified and implemented based upon the business requirements of the organization to which they are applied.

The template defines the following variables:

- **data_wireless_ssid_name**: String - Descriptive name for the SSID corresponding to employee traffic
- **guest_wireless_ssid_name**:  String - Descriptive name for the SSID corresponding to guest traffic
- **data_ssid_schedules_enabled**: Boolean - Enable Data SSID unavailability schedule 
- **guest_ssid_schedules_enabled**:  Boolean - Enable Guest SSID unavailability schedule 
- **guest_wireless_client_bw_down**: Integer (min=0, max=1000000) - Guest SSID upstream per-client rate-limit (0 = unlimited)
- **guest_wireless_client_bw_up**: Integer (min=0, max=1000000) - Guest SSID downstream per-client rate-limit (0 = unlimited)
- **guest_wireless_ssid_bw_down**: Integer (min=0, max=1000000) - Guest SSID upstream rate-limit (0 = unlimited)
- **guest_wireless_ssid_bw_up**: Integer (min=0, max=1000000) - Guest SSID upstream rate-limit (0 = unlimited)
- **guest_ssid_welcome_message**: String - Message displayed in Guest SSID pass-through splash page

### 🔍 settings Section

The **settings** sections configures various network-wide wireless device (AP) settings.  There are two parameters specified under settings:

- The first is the upgrade strategy which is hardcoded to minimize the time it takes to upgrade the APs. 
- The second is to disable wireless meshing, which prevents the APs from meshing. 

All other parameters not specified are left at default values. Please refer to the following URL for a full definition of the parameters available under wireless settings:

https://netascode.cisco.com/docs/data_models/meraki/networks_wireless/settings/

### 🔍 rf_profiles Section

The **rf_profiles** section configures a single profile named "Corp wireless rf profile". 

- Clients are steered to the best available AP during association (client balancing). This is the default setting and does not appear within the YAML configuration.

- Minimum bit rate supported is specified per RF band - 2.4, 5, 6 GHz, Rather than per AP. Minimum bit rates are left at their default settings per band.
- Selection of RF bands is configured on a per-SSID level, rather than across all SSIDs to which the RF profile is applied.
- For the 2.4 GHz RF band the settings are left at their defaults which depend on the regulatory domain where the AP is operating. 
- For the 5 GHz RF band the settings are left at their defaults which depend on the regulatory domain where the AP is operating. 
- For the 6 GHz RF band the settings are left at their defaults which depend on the regulatory domain where the AP is operating. 
- Enables radio transmission.

Please refer to the following URL and associated URLs for a full definition of the parameters available within an RF Profile:

https://netascode.cisco.com/docs/data_models/meraki/networks_wireless/ssid_settings/ssid_base/

### 🔍 ssids Section

The **ssids** section hardcodes two SSIDs - Data (SSID 5) and Guest (SSID 1).

- For the Data SSID:
    - The name of the SSID is defined as a variable (although it will be referred to as the Data SSID within this document).
    - All SSIDs are hardcoded to be enabled, advertised on all APs, and visible in beacons for the small branch design.
    - Authentication mode is set to 802.1x / WPA-EAP authentication via an external Radius server. 
    - Wi-Fi Protected Access (WPA) encryption mode is set for WPA Transition Mode. 802.11w Management Frame Protection (dot11w) is enabled but not mandatory, allowing for support for WPA3 with backward compatibility for WPA2.
    - VLAN tagging is enabled with the assignment of the VLAN to which the Data SSID is assigned hardcoded to VLAN 10. The Radius server overrides the default VLAN ID assigned to the Data SSID via group policy returned through the Filter-Id attribute. This is used to assign the VLAN to which wireless clients are assigned once authenticated.
    - 802.11r Fast Transition (dot11r) and Radius Change of Authorization (coa) are mutually exclusive for the version of wireless firmware which this document is currently based on. For the Data SSID, 802.11r Fast Transition has been enabled and Radius CoA disabled. Should CoA be desired, simply reverse the settings within the YAML code for the Data SSID. Future wireless firmware versions will support simultaneously enabling both parameters.
    - Per-client and per-SSID rate limits do not appear within the YAML configuration - meaning they are set to the default which is unlimited (no rate-limiting).
    - Traffic shaping is enabled on the Data SSID, using the 4 default traffic shaping rules. No Layer 7 firewall rules section appears within the YAML, since no no Layer 7 firewall rules have been defined for the small branch design. Should Layer 7 firewall rules be desired, the YAML code can be modified to add this section.
    - Wireless clients on the Data SSID are allowed to communicate with eachother and with wired clients on the LAN.
    - IP address assignment for wireless clients is via DHCP server (bridged mode), although not explicitely configure to be mandatory.
    - Enabling / disabling SSID availability via a schedule is configured as a variable. If enabled, the example schedule within the YAML code provides a basic example which can be modified to meet requirements.

- For the Guest SSID:
    - The name of the SSID is defined as a variable (although it will be referred to as the Guest SSID within this document).
    - All SSIDs are hardcoded to be enabled, advertised on all APs, and visible in beacons for the small branch design.
    - Authentication mode is set to open (no encryption).
    - VLAN tagging is enabled with the assignment of the VLAN to which the Guest SSID is hardcoded to be VLAN 50.
    - Per-client and per-SSID rate limits are defined as variables within the YAML for the Guest SSID.
    - Traffic shaping is enabled on the Guest SSID, using the 4 default traffic shaping rules. No Layer 7 firewall rules section appears within the YAML, since no no Layer 7 firewall rules have been defined for the small branch design. Should Layer 7 firewall rules be desired, the YAML code can be modified to add this section.
    - Wireless clients on the Guest SSID are not allowed to communicate with eachother or with wired clients on the LAN.
    - IP address assignment for wireless clients is via DHCP server (bridged mode), and also explicitely configure to be mandatory.
    - Enabling / disabling SSID availability via a schedule is configured as a variable. If enabled, the example schedule within the YAML code provides a basic example which can be modified to meet requirements.
    - A click-through splash-page is enabled for guest traffic with a variable defined for the splash-page welcome message.
    - Enabling / disabling SSID availability via a schedule is configured as a variable. If enabled, the example schedule within the YAML code provides a basic example which can be modified to meet requirements.

Please refer to the following URL and associated URLs for a full definition of the parameters available within an SSID:

https://netascode.cisco.com/docs/data_models/meraki/networks_wireless/ssid_settings/ssid_base/


