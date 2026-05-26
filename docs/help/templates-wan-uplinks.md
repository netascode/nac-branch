# 🌐 templates-wan-uplinks.nac.yaml File

The **templates-wan-uplinks.nac.yaml** file in the `data/` folder provides comprehensive WAN uplink configuration templates.  These templates provide complete coverage of all WAN uplink scenarios for Meraki MX appliances, and also aligns with schema.yaml and Meraki best practices.

 The following variables are defined within the various templates within the **templates-wan-uplinks.nac.yaml** file:

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

Note that IPv6 variables are commented out within the **templates-wan-uplinks.nac.yaml** file.  IPv6 is currently not supported when implementing dual secure routers in a warm spare configuration.  Hence, for the medium and large branch designs of Unified Branch Phase 2, any IPv6 configuration is not allowed within the configuration of any templates.  However for the small branch design, only a single secure router is supported.  Therefore, the IPv6 configuration can be manually uncommented for small branch designs.


## 🔍 Example Configurations Using Variables


### 📝 EXAMPLE 1: WAN1 DHCP, WAN2 DHCP (Most Common - Auto-configuration)

    Template: wan_dhcp_dhcp
    
    Variables to set:
      appliance_01_serial: "Q2XX-XXXX-XXXX"
      appliance_01_name: "Branch-01-MX67"
      wan1_enabled: true
      wan2_enabled: true

 
### 📝 EXAMPLE 2: WAN1 Static IPv4/IPv6, WAN2 DHCP

    Template: wan_static_dhcp
    
    Variables to set:
      appliance_01_serial: "Q2XX-YYYY-ZZZZ"
      appliance_01_name: "HQ-MX250"
      wan1_enabled: true
      wan1_ipv4_address: "203.0.113.10/29"
      wan1_ipv4_gateway: "203.0.113.9"
      wan1_ipv4_dns:
        - "8.8.8.8"
        - "8.8.4.4"
      wan1_ipv6_address: "2001:db8:1234::10/64"
      wan1_ipv6_gateway: "2001:db8:1234::1"
      wan1_ipv6_dns:
        - "2001:4860:4860::8888"
        - "2001:4860:4860::8844"
      wan2_enabled: true

 
### 📝 EXAMPLE 3: WAN1 DHCP, WAN2 Static IPv4/IPv6

    Template: wan_dhcp_static
    
    Variables to set:
      appliance_01_serial: "Q2XX-AAAA-BBBB"
      appliance_01_name: "Store-42-MX84"
      wan1_enabled: true
      wan2_enabled: true
      wan2_ipv4_address: "192.168.100.10/24"
      wan2_ipv4_gateway: "192.168.100.1"
      wan2_ipv4_dns:
        - "1.1.1.1"
        - "1.0.0.1"
      wan2_ipv6_address: "2001:db8:5678::10/64"
      wan2_ipv6_gateway: "2001:db8:5678::1"
      wan2_ipv6_dns:
        - "2606:4700:4700::1111"
        - "2606:4700:4700::1001"

 
### 📝 EXAMPLE 4: Both WAN Static (Full Manual Configuration)

    Template: wan_static_static
    
    Variables to set:
      appliance_01_serial: "Q2XX-CCCC-DDDD"
      appliance_01_name: "DC-MX450"
      wan1_enabled: true
      wan1_ipv4_address: "198.51.100.10/30"
      wan1_ipv4_gateway: "198.51.100.9"
      wan1_ipv4_dns:
        - "8.8.8.8"
        - "8.8.4.4"
      wan1_ipv6_address: "2001:db8:dc01::10/64"
      wan1_ipv6_gateway: "2001:db8:dc01::1"
      wan1_ipv6_dns:
        - "2001:4860:4860::8888"
        - "2001:4860:4860::8844"
      wan2_enabled: true
      wan2_ipv4_address: "198.51.100.14/30"
      wan2_ipv4_gateway: "198.51.100.13"
      wan2_ipv4_dns:
        - "1.1.1.1"
        - "1.0.0.1"
      wan2_ipv6_address: "2001:db8:dc02::10/64"
      wan2_ipv6_gateway: "2001:db8:dc02::1"
      wan2_ipv6_dns:
        - "2606:4700:4700::1111"
        - "2606:4700:4700::1001"

 
### 📝 EXAMPLE 5: PPPoE on WAN1, DHCP on WAN2

    Template: wan_pppoe_dhcp
    
    Variables to set:
      appliance_01_serial: "Q2XX-EEEE-FFFF"
      appliance_01_name: "Main-MX67"
      wan1_enabled: true
      wan1_pppoe_username: "user123@isp.com"
      wan1_pppoe_password: "SecurePass2024!"
      wan2_enabled: true

 
### 📝 EXAMPLE 6: DHCP on WAN1, PPPoE on WAN2

    Template: wan_dhcp_pppoe
    
    Variables to set:
      appliance_01_serial: "Q2XX-GGGG-HHHH"
      appliance_01_name: "West-MX84"
      wan1_enabled: true
      wan2_enabled: true
      wan2_pppoe_username: "backup@isp2.net"
      wan2_pppoe_password: "BackupPass456!"

 
### 📝 EXAMPLE 7: Dual PPPoE Configuration

    Template: wan_pppoe_pppoe
    
    Variables to set:
      appliance_01_serial: "Q2XX-IIII-JJJJ"
      appliance_01_name: "Remote-MX67C"
      wan1_enabled: true
      wan1_pppoe_username: "primary@isp1.com"
      wan1_pppoe_password: "PrimaryPass789!"
      wan2_enabled: true
      wan2_pppoe_username: "secondary@isp2.com"
      wan2_pppoe_password: "SecondaryPass012!"

 
### 📝 EXAMPLE 8: WAN1 VLAN Tagged DHCP, WAN2 VLAN Tagged DHCP

    Template: wan_vlan_vlan
    
    Variables to set:
      appliance_01_serial: "Q2XX-MMMM-NNNN"
      appliance_01_name: "TenantA-MX84"
      wan1_enabled: true
      wan1_vlan_id: 500
      wan2_enabled: true
      wan2_vlan_id: 501

 
### 📝 EXAMPLE 9: VLAN Tagged WAN1 Static, WAN2 DHCP

    Template: wan_vlan_static_dhcp
    
    Variables to set:
      appliance_01_serial: "Q2XX-KKKK-LLLL"
      appliance_01_name: "BuildingA-MX250"
      wan1_enabled: true
      wan1_vlan_id: 100
      wan1_ipv4_address: "10.100.1.10/24"
      wan1_ipv4_gateway: "10.100.1.1"
      wan1_ipv4_dns:
        - "10.0.1.53"
        - "10.0.2.53"
      wan1_ipv6_address: "2001:db8:vlan100::10/64"
      wan1_ipv6_gateway: "2001:db8:vlan100::1"
      wan1_ipv6_dns:
        - "2001:db8:dns::53"
      wan2_enabled: true

 
### 📝 EXAMPLE 10: IPv4 Only - WAN1 DHCP, WAN2 DHCP (Legacy)
 
    Variables to set:
      appliance_01_serial: "Q2XX-OOOO-PPPP"
      appliance_01_name: "Legacy-MX64"
      wan1_enabled: true
      wan1_ipv4_dns:
        - "10.0.1.53"        Internal DNS primary
        - "10.0.2.53"        Internal DNS secondary
        - "8.8.8.8"          External fallback
        - "8.8.4.4"          External fallback
        No IPv6 configuration
      wan2_enabled: true
        No IPv6 configuration

 
### 📝 EXAMPLE 11: IPv4 Only - WAN1 Static, WAN2 DHCP (Legacy)
 
    Variables to set:
      appliance_01_serial: "Q2XX-OOOO-PPPP"
      appliance_01_name: "Legacy-MX64"
      wan1_enabled: true
      wan1_ipv4_address: "192.0.2.10/24"
      wan1_ipv4_gateway: "192.0.2.1"
      wan1_ipv4_dns:
        - "10.0.1.53"        Internal DNS primary
        - "10.0.2.53"        Internal DNS secondary
        - "8.8.8.8"          External fallback
        - "8.8.4.4"          External fallback
        No IPv6 configuration
      wan2_enabled: true
        No IPv6 configuration


##  📖 Variable Reference Guide

    APPLIANCE:
      appliance_01_serial: String - Device serial number (format: QXXX-XXXX-XXXX)
      appliance_01_name: String - Descriptive device name

        WAN1 CONFIGURATION:
          wan1_enabled: Boolean - Enable/disable WAN1 (default: true)
          wan1_vlan_enabled: Boolean - Enable VLAN tagging (default: false)
          wan1_vlan_id: Integer - VLAN ID (1-4094)
          wan1_pppoe_enabled: Boolean - Enable PPPoE (default: false)
          wan1_pppoe_auth_enabled: Boolean - Enable PPPoE authentication (default: true)
          wan1_pppoe_username: String - PPPoE username
          wan1_pppoe_password: String - PPPoE password (5-64 characters)
          wan1_ipv4_mode: String - "dynamic" or "static"
          wan1_ipv4_address: String - IPv4 address with CIDR (e.g., "192.168.1.10/24")
          wan1_ipv4_gateway: String - IPv4 gateway address
          wan1_ipv4_dns: List - DNS servers (e.g., ["8.8.8.8", "8.8.4.4"])
          wan1_ipv6_address: String - IPv6 address with prefix (e.g., "2001:db8::10/64")
          wan1_ipv6_gateway: String - IPv6 gateway address
          wan1_ipv6_dns: List - IPv6 DNS servers

        WAN2 CONFIGURATION:
          wan2_enabled: Boolean - Enable/disable WAN2 (default: true)
          wan2_vlan_enabled: Boolean - Enable VLAN tagging (default: false)
          wan2_vlan_id: Integer - VLAN ID (1-4094)
          wan2_pppoe_enabled: Boolean - Enable PPPoE (default: false)
          wan2_pppoe_auth_enabled: Boolean - Enable PPPoE authentication (default: true)
          wan2_pppoe_username: String - PPPoE username
          wan2_pppoe_password: String - PPPoE password (5-64 characters)
          wan2_ipv4_mode: String - "dynamic" or "static"
          wan2_ipv4_address: String - IPv4 address with CIDR
          wan2_ipv4_gateway: String - IPv4 gateway address
          wan2_ipv4_dns: List - DNS servers
          wan2_ipv6_address: String - IPv6 address with prefix
          wan2_ipv6_gateway: String - IPv6 gateway address
          wan2_ipv6_dns: List - IPv6 DNS servers


 ## ✅ Best Practices and Recommendations

 1. HIGH AVAILABILITY:
    - Configure WAN1 as primary (higher bandwidth/reliability)
    - Configure WAN2 as backup/failover
    - Use different ISPs for true redundancy
    - Test failover scenarios regularly

 2. DNS CONFIGURATION:
    - Use geographically distributed DNS servers
    - Configure at least 2 DNS servers per WAN
    - Consider internal DNS for enterprise deployments
    - Popular public DNS options:
      * OpenDNS: 208.67.222.222, 208.67.220.220
      * Google: 8.8.8.8, 8.8.4.4
      * Cloudflare: 1.1.1.1, 1.0.0.1
      * Quad9: 9.9.9.9, 149.112.112.112

 3. IP ADDRESSING:
    - Use RFC 1918 for internal networks
    - /30 or /31 subnets for point-to-point WAN links
    - Ensure no IP conflicts between WAN interfaces
    - Document all static IP assignments

 4. PPPoE BEST PRACTICES:
    - Store credentials securely
    - Test authentication before production
    - Have ISP support contact readily available
    - Configure via local status page if needed

 5. VLAN TAGGING:
    - Coordinate with upstream switch/router config
    - Document VLAN assignments
    - Use different VLANs for WAN separation
    - Test VLAN configuration with packet captures

 6. IPv6 DEPLOYMENT:
    - Use /64 for standard subnets
    - Use /127 for point-to-point links
    - Ensure IPv6 DNS is configured
    - Test dual-stack functionality

 7. MONITORING:
    - Enable uplink statistics
    - Configure alerts for failover events
    - Monitor latency and packet loss
    - Review uplink utilization regularly

 7. SECURITY:
    - Change default credentials
    - Use strong PPPoE passwords
    - Implement firewall rules
    - Enable IDS/IPS on WAN interfaces

 8. TESTING CHECKLIST:
    ✓ Verify both WAN links connect
    ✓ Test failover by disconnecting primary
    ✓ Verify DNS resolution on both links
    ✓ Test throughput on each link
    ✓ Verify VLAN tags if configured
    ✓ Document configuration and test results

 9. FIRMWARE REQUIREMENTS:
     - MX 14.24+ for /31 subnet support
     - Check compatibility for specific features
     - Keep firmware updated for security
     - Test updates in lab environment first