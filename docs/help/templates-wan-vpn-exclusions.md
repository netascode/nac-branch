# 🌐 templates-wan-vpn-exclusions.nac.yaml File

The **templates-wan-vpn-exclusions.nac.yaml** file in the `data/` folder defines the following template:

- VPN exclusion policies - Defined in the **app_vpn_exclusions** template.

The template defines the following variables:

- None

The VPN exclusions template excludes traffic from the AutoVPN tunnels, allowing the traffic to reach the Internet directly from the branch.  VPN exclusions work when either the **hub_default_route** parameter is set to "true" within the **app_spoke** template in the **templates-appliance.nac.yaml** file for the hubs defined for the branch network; or when there is an IPsec VPN defined for the branch network with a default route associated with it.  This is discussed in the [Meraki Auto VPN - Configuration and Troubleshooting](https://documentation.meraki.com/SASE_and_SD-WAN/MX/Design_and_Configure/Configuration_Guides/Site-to-site_VPN/VPN_Full-Tunnel_Exclusion_(Application_and_IP%2F%2FURL_Based_Local_Internet_Breakout)) guide.

The intention is that the customer either has the SSE configuration defined for Unified Branch Phase 2, or does not.  When the customer has SSE, a default route must be associated with the 3rd party VPN tunnels, and the **hub_default_route** parameter must be set to "false".  When the customer does not have SSE, the **hub_default_route** parameter must be set to "true".  Under both of those scenarios, the VPN exclusions are valid.

The VPN exclusions defined for Unified Branch Phase 2 consist of the following:

- Microsoft 365 and Cisco WebEx SaaS applications
- Traffic destined for the Meraki cloud for management / control of branch infrastructure devices