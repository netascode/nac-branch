
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_traffic_shaping_vpn_exclusions = network.appliance.traffic_shaping.vpn_exclusions | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping.vpn_exclusions/custom{% if appliance_traffic_shaping_vpn_exclusions.custom is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/trafficShaping/vpnExclusions/byNetwork   ['{{ organization.name }}']   organization_appliance_traffic_shaping_vpn_exclusions
    ${network_appliance_traffic_shaping_vpn_exclusions}=    Get List Item By Key    ${organization_appliance_traffic_shaping_vpn_exclusions}[items]    key=networkName    value={{ network.name }}
    ${evaluated}=    Evaluate    {{ appliance_traffic_shaping_vpn_exclusions.custom }}
    ${validated}=    Validate Subset     ${network_appliance_traffic_shaping_vpn_exclusions}[custom]    ${evaluated}    ['destination', 'port', 'protocol']
    Should Be True   ${validated}

{% else %}
    Skip    appliance.traffic_shaping.vpn_exclusions.custom is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_vpn_exclusions/major_applications{% if appliance_traffic_shaping_vpn_exclusions.major_applications is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/trafficShaping/vpnExclusions/byNetwork   ['{{ organization.name }}']   organization_appliance_traffic_shaping_vpn_exclusions
    ${network_appliance_traffic_shaping_vpn_exclusions}=    Get List Item By Key    ${organization_appliance_traffic_shaping_vpn_exclusions}[items]    key=networkName    value={{ network.name }}
    ${evaluated}=    Evaluate    {{ appliance_traffic_shaping_vpn_exclusions.major_applications }}
    ${evaluated}=    Unflatten Dicts    ${evaluated}    add_key=id
    ${validated}=    Validate Subset     ${network_appliance_traffic_shaping_vpn_exclusions}[majorApplications]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.traffic_shaping.vpn_exclusions.major_applications is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
