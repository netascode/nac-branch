
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_traffic_shaping_rules = network.appliance.traffic_shaping.rules | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_rules/default_rules{% if appliance_traffic_shaping_rules.default_rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/rules   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_rules
    Should Be Equal As Strings   ${appliance_traffic_shaping_rules}[defaultRulesEnabled]   {{ appliance_traffic_shaping_rules.default_rules }}

{% else %}
    Skip    appliance_traffic_shaping_rules.default_rules is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_rules/rules{% if appliance_traffic_shaping_rules.rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/rules   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_rules
    ${evaluated}=    Evaluate    {{ appliance_traffic_shaping_rules.rules }}
    ${evaluated}=    Map Application IDs To API    ${evaluated}    path=definitions
    ${validated}=    Validate Subset     ${appliance_traffic_shaping_rules}[rules]    ${evaluated}     ['definitions.type', 'definitions.value', 'per_client_bandwidth_limits.settings', 'per_client_bandwidth_limits.bandwidth_limits.limit_up', 'per_client_bandwidth_limits.bandwidth_limits.limit_down', 'dscp_tag_value', 'priority']
    Should Be True   ${validated}

{% else %}
    Skip    appliance_traffic_shaping_rules.rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
