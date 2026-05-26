
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_connectivity_monitoring_destinations = network.appliance.connectivity_monitoring_destinations | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.connectivity_monitoring_destinations{% if appliance_connectivity_monitoring_destinations is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/connectivityMonitoringDestinations   ['{{ organization.name }}', '{{ network.name }}']   appliance_connectivity_monitoring_destinations
    ${evaluated}=    Evaluate    {{ appliance_connectivity_monitoring_destinations }}
    ${validated}=    Validate Subset     ${appliance_connectivity_monitoring_destinations}[destinations]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.connectivity_monitoring_destinations is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
