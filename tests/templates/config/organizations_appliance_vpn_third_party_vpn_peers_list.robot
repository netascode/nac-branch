
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for vpn_peer in organization.appliance.third_party_vpn_peers | default([], true) %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//name{% if vpn_peer.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[name]   {{ vpn_peer.name }}

{% else %}
    Skip    vpn_peer.name is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//public_ip{% if vpn_peer.public_ip is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[publicIp]   {{ vpn_peer.public_ip }}

{% else %}
    Skip    vpn_peer.public_ip is not defined
{% endif %}
# Note: publicHostname is not included in GET response OpenAPI spec, but is actually returned.
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//public_hostname{% if vpn_peer.public_hostname is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[publicHostname]   {{ vpn_peer.public_hostname }}

{% else %}
    Skip    vpn_peer.public_hostname is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//remote_id{% if vpn_peer.remote_id is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[remoteId]   {{ vpn_peer.remote_id }}

{% else %}
    Skip    vpn_peer.remote_id is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//local_id{% if vpn_peer.local_id is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[localId]   {{ vpn_peer.local_id }}

{% else %}
    Skip    vpn_peer.local_id is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//ike_version{% if vpn_peer.ike_version is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[ikeVersion]   {{ vpn_peer.ike_version }}

{% else %}
    Skip    vpn_peer.ike_version is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//private_subnets{% if vpn_peer.private_subnets is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    ${evaluated}=    Evaluate    {{ vpn_peer.private_subnets }}
    ${validated}=    Validate Subset     ${peer}[privateSubnets]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    vpn_peer.private_subnets is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//network_tags{% if vpn_peer.network_tags is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    ${evaluated}=    Evaluate    {{ vpn_peer.network_tags }}
    ${validated}=    Validate Subset     ${peer}[networkTags]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    vpn_peer.network_tags is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//ipsec_policies{% if vpn_peer.ipsec_policies is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    ${evaluated}=    Evaluate    {{ vpn_peer.ipsec_policies }}
    ${validated}=    Validate Subset     ${peer}[ipsecPolicies]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    vpn_peer.ipsec_policies is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//ipsec_policies_preset{% if vpn_peer.ipsec_policies_preset is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[ipsecPoliciesPreset]   {{ vpn_peer.ipsec_policies_preset }}

{% else %}
    Skip    vpn_peer.ipsec_policies_preset is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//is_route_based{% if vpn_peer.is_route_based is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[isRouteBased]   {{ vpn_peer.is_route_based }}

{% else %}
    Skip    vpn_peer.is_route_based is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//priority_in_group{% if vpn_peer.priority_in_group is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[priorityInGroup]   {{ vpn_peer.priority_in_group }}

{% else %}
    Skip    vpn_peer.priority_in_group is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//group_number{% if vpn_peer.group_number is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[group][number]   {{ vpn_peer.group_number }}

{% else %}
    Skip    vpn_peer.group_number is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//group_active_active_tunnel{% if vpn_peer.group_active_active_tunnel is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[group][activeActiveTunnel]   {{ vpn_peer.group_active_active_tunnel }}

{% else %}
    Skip    vpn_peer.group_active_active_tunnel is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//group_failover_direct_to_internet{% if vpn_peer.group_failover_direct_to_internet is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Should Be Equal As Strings   ${peer}[group][failover][directToInternet]   {{ vpn_peer.group_failover_direct_to_internet }}

{% else %}
    Skip    vpn_peer.group_failover_direct_to_internet is not defined
{% endif %}
Verify {{ organization.name }}/third_party_vpn_peers/{{ vpn_peer.name }}//sla_policy_name{% if vpn_peer.sla_policy_name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/thirdPartyVPNPeers   ['{{ organization.name }}']   appliance_vpn_third_party_vpn_peers
    ${peer}=    Get List Item By Key    ${appliance_vpn_third_party_vpn_peers}[peers]    key=name    value={{ vpn_peer.name }}
    Get Meraki Data   /organizations/{organizationId}/appliance/vpn/siteToSite/ipsec/peers/slas   ['{{ organization.name }}']   appliance_vpn_site_to_site_ipsec_peers_slas
    ${sla}=    Get List Item By Key    ${appliance_vpn_site_to_site_ipsec_peers_slas}[items]    key=name    value={{ vpn_peer.sla_policy_name }}
    Should Be Equal As Strings   ${peer}[slaPolicy][id]   ${sla}[id]

{% else %}
    Skip    vpn_peer.sla_policy_name is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
