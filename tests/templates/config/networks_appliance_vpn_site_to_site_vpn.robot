
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_vpn_site_to_site_vpn = network.appliance.vpn_site_to_site_vpn | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_site_to_site_vpn/mode{% if appliance_vpn_site_to_site_vpn.mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/siteToSiteVpn   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_site_to_site_vpn
    Should Be Equal As Strings   ${appliance_vpn_site_to_site_vpn}[mode]   {{ appliance_vpn_site_to_site_vpn.mode }}

{% else %}
    Skip    appliance_vpn_site_to_site_vpn.mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_site_to_site_vpn/hubs{% if appliance_vpn_site_to_site_vpn.hubs is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/siteToSiteVpn   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_site_to_site_vpn
    ${evaluated}=    Evaluate    {{ appliance_vpn_site_to_site_vpn.hubs }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}    ['{{ organization.name }}']    name_prop=hub_network_name    id_prop=hub_id
    ${validated}=    Validate Subset     ${appliance_vpn_site_to_site_vpn}[hubs]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vpn_site_to_site_vpn.hubs is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_site_to_site_vpn/subnets{% if appliance_vpn_site_to_site_vpn.subnets is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/siteToSiteVpn   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_site_to_site_vpn
    ${evaluated}=    Evaluate    {{ appliance_vpn_site_to_site_vpn.subnets }}
    ${appliance_vpn_site_to_site_vpn}=    Filter API Site To Site VPN Subnets    ${appliance_vpn_site_to_site_vpn}    ${evaluated}
    ${validated}=    Validate Subset     ${appliance_vpn_site_to_site_vpn}[subnets]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vpn_site_to_site_vpn.subnets is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_site_to_site_vpn/subnet_nat{% if appliance_vpn_site_to_site_vpn.subnet_nat is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/siteToSiteVpn   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_site_to_site_vpn
    Should Be Equal As Strings   ${appliance_vpn_site_to_site_vpn}[subnet][nat][isAllowed]   {{ appliance_vpn_site_to_site_vpn.subnet_nat }}

{% else %}
    Skip    appliance_vpn_site_to_site_vpn.subnet_nat is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
