*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set appliance_vpn_site_to_site_ipsec_peers_slas = organization.appliance.vpn_site_to_site_ipsec_peers_slas | default(none) %}
Verify {{ organization.name }}/appliance_vpn_site_to_site_ipsec_peers_slas/items{% if appliance_vpn_site_to_site_ipsec_peers_slas is not none %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/siteToSite/ipsec/peers/slas   ['{{ organization.name }}']   appliance_vpn_site_to_site_ipsec_peers_slas
    ${evaluated}=    Evaluate    {{ appliance_vpn_site_to_site_ipsec_peers_slas }}
    ${validated}=    Validate Subset     ${appliance_vpn_site_to_site_ipsec_peers_slas}[items]    ${evaluated}     ['name', 'uri']
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vpn_site_to_site_ipsec_peers_slas is not defined
{% endif %}

{% endfor %}
{% endfor %}
