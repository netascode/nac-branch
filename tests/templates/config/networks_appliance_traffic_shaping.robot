
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_traffic_shaping = network.appliance.traffic_shaping | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping/global_bandwidth_limits{% if appliance_traffic_shaping.global_bandwidth_limits is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping
    ${evaluated}=    Evaluate    {{ appliance_traffic_shaping.global_bandwidth_limits }}
    ${validated}=    Validate Subset     ${appliance_traffic_shaping}[globalBandwidthLimits]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.traffic_shaping.global_bandwidth_limits is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
