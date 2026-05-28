## 2.0.0

May 2026

### New Features

- **Medium and Large Branch Support**: Added medium  and large site design with 2 appliances in active-backup (warm spare) configuration, including dedicated inventory, variables, and network templates
- **New Style Templates**: Migrated all data templates to new-style YAML template format with per-feature separation
- **3rd Party VPN Peers**: Added support for third-party VPN peers (IPsec) at the organization level, including Cisco Secure Access (SSE) integration
- **IP SLA Monitoring**: Added VPN site-to-site IPsec peers SLA policy configuration for 3rd party VPN health checks
- **Adaptive Policy**: Added adaptive policy support including policy groups, ACLs, policies, and settings at the organization level
- **Splunk Webhooks**: Enabled Splunk integration via real-time webhook alerts
- **Fixed IP Assignments Template**: Moved fixed IP assignments to a dedicated `tftpl` template to handle a variable number of devices
- **Switch Access Policy Template**: Added switch access policy as a `tftpl` template for RADIUS-based 802.1X configurations
- **Wireless RADIUS Template**: Added wireless RADIUS server configuration as a `tftpl` template
- **RADIUS Authentication Servers**: Added organization-level RADIUS authentication server support


### Improvements

- **STP Bridge Priority**: Changed switch STP bridge priority to 4096 for all branch sizes
- **Traffic Shaping**: Updated traffic shaping rules and custom performance classes aligned with CVD
- **Internet Policies**: Updated SD-WAN internet policies and uplink selection configuration
- **VPN Firewall Rules**: Synced VPN firewall policy with CVD, added VPN route exclusions
- **L3/L7 Firewall**: Updated Layer 3, Layer 7, and firewalled services policies aligned with CVD
- **WAN Uplinks**: Updated WAN uplink configuration and failover settings
- **Wireless**: Added RF profile assignments to APs, updated SSID configurations
- **Network Tags**: Added unified branch tag to networks and inventory for tracking
- **Group Policies**: Updated group policy and named policy object configurations
- **Schema**: Updated schema to latest nac-meraki version with expanded appliance, switch, and wireless definitions
- **Jenkins Pipeline**: Redesigned CI/CD pipeline with separate Validate, Plan, Deploy, and Test stages; added artifact archiving; added idempotency testing; added Webex notifications
- **Module Reference**: Updated to module version 0.9.0

### Breaking Changes

- **Introduced new template structure** - Templates now can be configuration or file based. The schema has changed, updated configs with `type` (can be model if configuration or file if using the tftpl files)
- **Removed IPv6 from medium branch WAN DHCP template** (following schema and API changes)
- **Removed static routes** from appliance configuration
- **Removed old `workspaces/` directory** — Terraform workspace configuration moved to root `main.tf`; the `workspaces/` directory and its `main.tf` are no longer used
- **Jenkins Pipeline**: Removed references to `/workspaces` directory; pipeline now operates from the repository root


## 1.1.0

January 2026

- Update to Module version to 0.6.0

- Add support for networks netflow configuration

- Added DHCP Relay Support (dhcp_relay_server_ips)

- Added support for fixed_ip_assignments 

Breaking changes: 

- Capitalize "Event" in Syslog events names (folowing Mearki API change)

- Removed support for IPv6 from VLAN settings, as well as from schema (following the schama change)

        "ipv6:
            enabled: false"
      
- Removed "is_indoor_default" from schema and configuration 


## 1.0.0

Initial Release - November 2025

- Branch inventory management: Define and manage small branch network infrastructure including devices, networks, and organizational hierarchy  
- Appliance configuration: Configure MX appliance general settings including naming, timezone, and management interface settings  
- VPN spoke configuration: Set up auto-VPN spoke configurations for branch-to-hub connectivity  
- Port and VLAN management: Configure appliance physical ports, VLAN assignments, and network segmentation  
- Firewall policies: Define Layer 3 and Layer 7 firewall rules for traffic filtering and security control  
- Content filtering: Configure web content filtering policies to control access to specific websites and categories  
- Intrusion detection and prevention: Enable and configure IDS/IPS rulesets for threat detection  
- Malware protection: Configure anti-malware settings and protection modes for network security  
- Internet policies: Define traffic shaping and routing policies for internet-bound traffic  
- Group policies: Create client-level policy groups for applying differentiated settings to specific users or devices  
- Switch configuration: Configure switch port settings, VLANs, and Layer 2 features  
- Traffic shaping rules: Define bandwidth limits and QoS policies for traffic prioritization  
- WAN uplink settings: Configure WAN interfaces, failover behavior, and load balancing for internet connectivity  
- Wireless networks: Define SSIDs, authentication methods, and wireless security policies  

Enhacements:   
- Reference already preconfigured Hub
