# Dashboard Device Initial Onboarding Flow and Best Practices

## Overview

This document explains the Meraki device initial onboarding process and demonstrates best practice VLAN design, specifically covering the migration from VLAN 1 (onboard) to VLAN 999 (management) and the integration with Auto VPN for centralized DHCP services. This applies to all Meraki devices including switches (MS), access points (MR), cameras (MV), and sensors (MT).

## Example VLAN Structure and Purpose

| VLAN | Name | Purpose | DHCP Source |
|------|------|---------|-------------|
| 1 | Onboard | Initial device connectivity and dashboard registration | Local MX |
| 10 | Data | Corporate user traffic | Local MX or Central |
| 20 | Voice | Corporate Voice traffic | Local MX or Central |
| 30 | IOT | IoT device traffic | Local MX or Central |
| 50 | Guest | Guest network traffic | Local MX |
| 999 | MGMT | Management traffic after configuration pull | Local MX or Central DHCP via Auto VPN |

## Initial Device Onboarding Process

### Phase 1: Initial Connection (VLAN 1 - Onboard)

1. **Power On and Default Behavior**
   - New Meraki device powers on with factory defaults
   - Device initially operates on VLAN 1 (native/untagged)
   - Device attempts DHCP discovery on VLAN 1

2. **Dashboard Registration**
   - Device obtains IP address from MX DHCP on VLAN 1
   - Establishes internet connectivity through MX VLAN 1
   - Contacts Meraki Dashboard for initial configuration via HTTPS Encrypted Connection
   - Downloads network configuration and policies

3. **Configuration Download**
   - Device pulls its specific configuration from Dashboard assuming it has been claim and assigned to a network
   - Device-specific configurations, VLAN assignments, and management settings downloaded
   - Management VLAN setting retrieved (configured as VLAN 999)

### Phase 2: Management VLAN Migration (VLAN 1 → VLAN 999)

1. **Management VLAN Activation**
   - Device applies new configuration with management VLAN set to VLAN 999
   - Device initiates DHCP discovery on VLAN 999
   - VLAN 999 traffic routes through Auto VPN to central DHCP server

2. **IP Address Assignment**
   - Central DHCP server (in DC) assigns management IP to device
   - DHCP reservation based on device MAC address
   - Device maintains connectivity to Dashboard via VLAN 999. Note although DHCP address is obtained from central DHCP server, the route to dashboard can either be via the Auto-VPN or via local breakout of the MX internet interface.

3. **Operational State**
   - Device management now operates exclusively on VLAN 999
   - VLAN 1 DHCP services can be disabled if not required until new device onboarding
   - All Dashboard communication occurs via VLAN 999 management interface

## Device-Specific Management VLAN Configuration

### Switches (MS Series)
**Dashboard Location**: `Switch > Configure > Switch Settings > Management VLAN`
- **Network-wide**: `Switch > Configure > Switch Settings > Management VLAN`  
- **Per-device**: Individual switch configuration page
- **Template Support**: Full template support available
- **Best Practice**: Configure via switch template for consistency

### Access Points (MR Series)
**Dashboard Location**: `Wireless > Configure > Access Points > [Select AP] > Management`
- **Network-wide**: `Wireless > Configure > Access Points > Management VLAN`
- **Per-device**: Individual AP configuration page  
- **Template Support**: Limited template support
- **Best Practice**: Set network-wide default, override individually if needed

### Cameras (MV Series)
**Dashboard Location**: `Cameras > Configure > Cameras > [Select Camera] > Settings`
- **Network-wide**: `Cameras > Configure > Video Settings > Management VLAN`
- **Per-device**: Individual camera configuration page
- **Template Support**: Basic template support
- **Best Practice**: Configure network-wide default for new deployments

### Sensors (MT Series)
**Dashboard Location**: `Environmental > Configure > Sensors > [Select Sensor] > Settings`
- **Network-wide**: `Environmental > Configure > Settings > Management VLAN`
- **Per-device**: Individual sensor configuration page
- **Template Support**: Limited template support  
- **Best Practice**: Set at network level for simplicity

## Device Behavior by Platform Type

### Switches (MS/Catalyst Series)

#### Auora 1 
- **VLAN Snooping**: Requires VLAN 1 snooping to be explicitly enabled
- **Behavior**: Must have active VLANs configured before deployment
- **Limitation**: Cannot auto-discover VLANs, requires pre-configuration
- **Best Practice**: Configure management VLAN before deployment

#### Auora 2
- **VLAN Snooping**: Looks only for active VLANs first
- **Fallback Behavior**: If no active VLANs detected, starts snooping VLAN 1-1000
- **Intelligence**: More adaptive than Auora 1, better auto-discovery
- **Best Practice**: Can be deployed with minimal pre-configuration

#### Meraki Native
- **VLAN Snooping**: Will snoop all VLANs automatically
- **Behaviour**: Starts with VLAN 1-1000 by default
- **Intelligence**: Highest level of auto-discovery and adaptation
- **Best Practice**: Zero-touch deployment capable

### Access Points (MR Series)
- **VLAN Discovery**: Automatic VLAN detection and adaptation
- **Fallback**: Always falls back to VLAN 1 if configured management VLAN unavailable
- **Bridge vs Router Mode**: Behavior consistent across both modes
- **Best Practice**: Zero-touch deployment supported

### Cameras (MV Series)  
- **VLAN Discovery**: Automatic detection with VLAN 1 fallback
- **Behavior**: Similar to access points, robust VLAN discovery
- **Power Considerations**: PoE+ requirements may affect initial connectivity
- **Best Practice**: Ensure adequate PoE budget for initial onboarding

### Sensors (MT Series)
- **VLAN Discovery**: Basic VLAN detection capabilities
- **Behavior**: Simple onboarding process, inherits network settings
- **Power**: Low power requirements, typically PoE compatible
- **Best Practice**: Minimal configuration required

## Auto VPN and Central DHCP Integration

### Auto VPN Configuration

1. **Spoke Configuration (Branch Sites)**
   ```
   MX Spoke Configuration:
   - Auto VPN enabled as Spoke
   - VLAN 999 routing to Hub via VPN
   - No local DHCP for VLAN 999
   - DHCP relay enabled for VLAN 999 to Central DHCP Server
   - Route propagation enabled for VLAN 999
   - Either VLAN 999 uses Auto VPN or local breakout of the MX internet interface to reach the Central DHCP Server
   ```

### DHCP Reservation Strategy

1. **Central DHCP Server Setup**
   - Windows DHCP or applicable IPAM solution in data center
   - VLAN 999 scope (e.g., 10.2.0.0/24)
   - Reservations based on device MAC addresses
   - Optional dhcp assignment based on client identifier
   - DHCP options for DNS, NTP, and management services

2. **Reservation Examples**
   ```
   # Switch Example
   Switch Model: MS390-24P
   MAC Address: 00:18:0a:12:34:56
   Reserved IP: 10.2.0.101
   Hostname: SW-BRANCH01-IDF01
   
   # Access Point Example
   AP Model: MR57
   MAC Address: 00:18:0a:78:9a:bc
   Reserved IP: 10.2.0.201
   Hostname: AP-BRANCH01-FL02
   
   # Camera Example
   Camera Model: MV12W
   MAC Address: 00:18:0a:de:f1:23
   Reserved IP: 10.2.0.301
   Hostname: CAM-BRANCH01-LOBBY
   
   # Sensor Example
   Sensor Model: MT10
   MAC Address: 00:18:0a:45:67:89
   Reserved IP: 10.2.0.401
   Hostname: SENS-BRANCH01-SERVER
   ```

## Best Practice Implementation Guide

### Pre-Deployment Configuration

1. **Dashboard Network Setup**
   ```
   Network Settings:
   - Create network
   - Configure VLAN 999 as management VLAN for all device types
   - Set device templates with VLAN 999 management (switches, APs)
   - Configure network-wide management VLAN for cameras and sensors
   - Configure Auto VPN settings
   ```

2. **MX Base Configuration**
   ```
   MX Security Appliance:
   - VLAN 1: 192.168.128.0/24 ( default onboarding)
   - VLAN 999: Routed via Auto VPN to DC
   - DHCP enabled on VLAN 1
   - DHCP relay enabled for VLAN 999 to Central DHCP Server
   - Auto VPN enabled as Spoke with Hub site pre-configured
   - Route All VLAN 999 traffic via VPN tunnel or optionally only management services via VPN tunnel, with dashboard connectivity via local breakout of the MX internet interface
   ```

3. **Central DHCP Server Configuration**
   ```
   Central DHCP Server:
   - VLAN 999 scope (e.g., 10.2.0.0/24)
   - Reservations based on device MAC addresses
   - Optional dhcp assignment based on client identifier
   - DHCP options for DNS, NTP, and management services
   ```

### Deployment Process

1. **Physical Installation**
   - Esnure MX is stable and online and has the MX Base Configuration applied.
   - Connect device to the network (switch port or PoE+ for cameras)
   - Ensure device can reach VLAN 1 for initial onboarding
   - Power on device and wait for Dashboard connection and ensure that the light on the device is solid green.
   - Verify device appears in Dashboard inventory

2. **Configuration Application**
   - Device automatically pulls configuration
   - Monitor management IP assignment on VLAN 999
   - Verify Auto VPN tunnel connectivity
   - Confirm central DHCP reservation

3. **Validation**

   - Verify management connectivity for all device types either by pinging there address from the central NMS or by logging into the dashboard and pinging the management IP.
   Navigate to: Inventory > [Select Device] > Management IP
   
   - Check Auto VPN status in Dashboard
   Navigate to: Security & SD-WAN > Monitor > VPN status
   
   - Validate DHCP leases in central server
   Check DHCP server for all active device leases
   
   - Device-specific validation
   - Switches: Check port status and VLAN assignments
   - APs: Verify wireless network broadcasting
   - Cameras: Confirm video streaming functionality
   - Sensors: Check environmental data reporting
   This assumes that all additional configuration has been completed.
   ```

## Troubleshooting Common Issues

### Device Cannot Contact Dashboard

1. **VLAN 1 Connectivity Issues**
   - Verify MX DHCP is functioning on VLAN 1
   - Check internet connectivity from MX
   - Ensure Dashboard access isn't blocked by an upstream firewall

2. **Management VLAN Issues**
   - Verify VLAN 999 is properly configured in Dashboard for specific device type
   - Check Auto VPN tunnel status
   - Validate central DHCP server accessibility
   - Confirm device-specific management VLAN settings are applied

### Auto VPN Connectivity Problems

1. **Tunnel Establishment**
   - Verify MX can reach Meraki cloud
   - Check NAT/firewall rules for VPN traffic
   - Validate MX licensing and organization membership

2. **DHCP Relay Issues**
   - Ensure VLAN 999 routes properly via VPN
   - Check DHCP relay configuration on hub MX
   - Validate DHCP server is responding to remote subnets

## Security Considerations

### Management VLAN Isolation
- VLAN 999 should be isolated from user traffic
- Implement access control lists limiting management access
- Use dedicated management subnet with controlled routing

Please note that VRF is not currently supported on the MX and as such the management VLAN is not isolated from user traffic.

### Network Segmentation
- Separate management traffic from production traffic
- Implement VLAN-based security policies or Adaptive Policy
- Monitor management traffic for anomalies


## Summary

The Meraki device onboarding flow leveraging VLAN 1 for initial connectivity and VLAN 999 for management provides a robust, scalable approach to comprehensive network infrastructure management. This design pattern works consistently across all dashboard supporteddevice types - switches (MS/Catalyst), access points (MR/Catalyst), cameras (MV), and sensors (MT) - and combined with Auto VPN and central DHCP services, enables zero-touch deployment while maintaining centralized control and security.

The key benefits of this approach include:
- **Unified Deployment**: All  devices (switches, APs, cameras, sensors) follow the same onboarding pattern
- **Centralized Management**: Comprehensive device management from central DHCP and Dashboard
- **Scalability**: Consistent deployment process across all sites and device types
- **Security**: Management traffic isolated and controlled for entire infrastructure
- **Simplified Operations**: Single management VLAN strategy reduces complexity

By following these best practices and understanding the device-specific behaviors, organizations can implement a robust, comprehensive Meraki infrastructure that includes switching, wireless, security cameras, and environmental monitoring - all managed through a unified approach that scales efficiently and maintains security standards.

## References

### Official Cisco Meraki Documentation

#### Switch Documentation
1. **Switch Settings - Cisco Meraki Documentation**  
   *Management VLAN configuration and initial setup procedures*  
   https://documentation.meraki.com/MS/Other_Topics/Switch_Settings

2. **General MS Best Practices - Cisco Meraki Documentation**  
   *Native VLAN and trunk configuration recommendations*  
   https://documentation.meraki.com/Architectures_and_Best_Practices/Cisco_Meraki_Best_Practice_Design/Best_Practice_Design_-_MS_Switching/General_MS_Best_Practices

#### Access Point Documentation
3. **MR Access Point Settings - Cisco Meraki Documentation**  
   *Management VLAN configuration for wireless access points*  
   https://documentation.meraki.com/MR/Other_Topics/MR_Access_Point_Settings

4. **Wireless LAN Best Practices - Cisco Meraki Documentation**  
   *Deployment and management VLAN recommendations for wireless*  
   https://documentation.meraki.com/Architectures_and_Best_Practices/Cisco_Meraki_Best_Practice_Design/Best_Practice_Design_-_MR_Wireless

#### Camera Documentation
5. **MV Camera Settings - Cisco Meraki Documentation**  
   *Management VLAN and network configuration for security cameras*  
   https://documentation.meraki.com/MV/Other_Topics/MV_Camera_Settings

6. **Video Best Practices - Cisco Meraki Documentation**  
   *Network requirements and VLAN considerations for video*  
   https://documentation.meraki.com/Architectures_and_Best_Practices/Cisco_Meraki_Best_Practice_Design/Best_Practice_Design_-_MV_Security_Cameras

#### Sensor Documentation
7. **MT Sensor Settings - Cisco Meraki Documentation**  
   *Management configuration for environmental sensors*  
   https://documentation.meraki.com/MT/Other_Topics/MT_Sensor_Settings

#### Cross-Platform Documentation
8. **VLAN Profiles - Cisco Meraki Documentation**  
   *Zero-touch provisioning and VLAN management across all device types*  
   https://documentation.meraki.com/General_Administration/Cross-Platform_Content/VLAN_Profiles

9. **Configuring VLANs on the MX Security Appliance - Cisco Meraki Documentation**  
   *VLAN configuration and routing setup for MX devices*  
   https://documentation.meraki.com/MX/Networks_and_Routing/Configuring_VLANs_on_the_MX_Security_Appliance


---

*Document Version: 2.0*  
*Last Updated: November 3, 2025*  
*Author: Jon Humphries*
