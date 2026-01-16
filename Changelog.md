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
