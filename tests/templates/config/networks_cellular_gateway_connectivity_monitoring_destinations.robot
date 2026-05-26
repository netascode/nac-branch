
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set cellular_gateway_connectivity_monitoring_destinations = network.cellular_gateway.connectivity_monitoring_destinations | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_connectivity_monitoring_destinations{% if cellular_gateway_connectivity_monitoring_destinations is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/connectivityMonitoringDestinations   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_connectivity_monitoring_destinations
    ${evaluated}=    Evaluate    {{ cellular_gateway_connectivity_monitoring_destinations }}
    ${validated}=    Validate Subset     ${cellular_gateway_connectivity_monitoring_destinations}[destinations]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_connectivity_monitoring_destinations is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
