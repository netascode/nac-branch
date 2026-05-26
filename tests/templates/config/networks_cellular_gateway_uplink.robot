
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set cellular_gateway_uplink_bandwidth_limits = network.cellular_gateway.uplink_bandwidth_limits | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_uplink/bandwidth_limits{% if cellular_gateway_uplink_bandwidth_limits is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/uplink   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_uplink
    ${evaluated}=    Evaluate    {{ cellular_gateway_uplink_bandwidth_limits }}
    ${validated}=    Validate Subset     ${cellular_gateway_uplink}[bandwidthLimits]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_uplink_bandwidth_limits is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
