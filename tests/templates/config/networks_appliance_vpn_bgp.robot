
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_vpn_bgp = network.appliance.vpn_bgp | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_bgp/enabled{% if appliance_vpn_bgp.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/bgp   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_bgp
    Should Be Equal As Strings   ${appliance_vpn_bgp}[enabled]   {{ appliance_vpn_bgp.enabled }}

{% else %}
    Skip    appliance_vpn_bgp.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_bgp/as_number{% if appliance_vpn_bgp.as_number is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/bgp   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_bgp
    Should Be Equal As Strings   ${appliance_vpn_bgp}[asNumber]   {{ appliance_vpn_bgp.as_number }}

{% else %}
    Skip    appliance_vpn_bgp.as_number is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_bgp/ibgp_hold_timer{% if appliance_vpn_bgp.ibgp_hold_timer is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/bgp   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_bgp
    Should Be Equal As Strings   ${appliance_vpn_bgp}[ibgpHoldTimer]   {{ appliance_vpn_bgp.ibgp_hold_timer }}

{% else %}
    Skip    appliance_vpn_bgp.ibgp_hold_timer is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vpn_bgp/neighbors{% if appliance_vpn_bgp.neighbors is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vpn/bgp   ['{{ organization.name }}', '{{ network.name }}']   appliance_vpn_bgp
    ${evaluated}=    Evaluate    {{ appliance_vpn_bgp.neighbors }}
    ${evaluated}=    Unflatten Dicts In Property    ${evaluated}    prop=ttl_security    add_key=enabled
    ${validated}=    Validate Subset     ${appliance_vpn_bgp}[neighbors]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vpn_bgp.neighbors is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
