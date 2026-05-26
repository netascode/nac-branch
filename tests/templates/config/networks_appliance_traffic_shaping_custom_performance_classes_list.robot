
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for appliance_traffic_shaping_custom_performance_classe in network.appliance.traffic_shaping.custom_performance_classes | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_custom_performance_classes/{{ appliance_traffic_shaping_custom_performance_classe.name }}//name{% if appliance_traffic_shaping_custom_performance_classe.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_traffic_shaping_custom_performance_classe.name }}']   appliance_traffic_shaping_custom_performance_classe
    Should Be Equal As Strings   ${appliance_traffic_shaping_custom_performance_classe}[name]   {{ appliance_traffic_shaping_custom_performance_classe.name }}

{% else %}
    Skip    appliance_traffic_shaping_custom_performance_classe.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_custom_performance_classes/{{ appliance_traffic_shaping_custom_performance_classe.name }}//max_latency{% if appliance_traffic_shaping_custom_performance_classe.max_latency is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_traffic_shaping_custom_performance_classe.name }}']   appliance_traffic_shaping_custom_performance_classe
    Should Be Equal As Strings   ${appliance_traffic_shaping_custom_performance_classe}[maxLatency]   {{ appliance_traffic_shaping_custom_performance_classe.max_latency }}

{% else %}
    Skip    appliance_traffic_shaping_custom_performance_classe.max_latency is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_custom_performance_classes/{{ appliance_traffic_shaping_custom_performance_classe.name }}//max_jitter{% if appliance_traffic_shaping_custom_performance_classe.max_jitter is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_traffic_shaping_custom_performance_classe.name }}']   appliance_traffic_shaping_custom_performance_classe
    Should Be Equal As Strings   ${appliance_traffic_shaping_custom_performance_classe}[maxJitter]   {{ appliance_traffic_shaping_custom_performance_classe.max_jitter }}

{% else %}
    Skip    appliance_traffic_shaping_custom_performance_classe.max_jitter is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_custom_performance_classes/{{ appliance_traffic_shaping_custom_performance_classe.name }}//max_loss_percentage{% if appliance_traffic_shaping_custom_performance_classe.max_loss_percentage is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_traffic_shaping_custom_performance_classe.name }}']   appliance_traffic_shaping_custom_performance_classe
    Should Be Equal As Strings   ${appliance_traffic_shaping_custom_performance_classe}[maxLossPercentage]   {{ appliance_traffic_shaping_custom_performance_classe.max_loss_percentage }}

{% else %}
    Skip    appliance_traffic_shaping_custom_performance_classe.max_loss_percentage is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
