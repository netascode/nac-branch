
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set traffic_shaping_rules = wireless_ssid.traffic_shaping_rules | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/traffic_shaping_rules/traffic_shaping_enabled{% if traffic_shaping_rules.traffic_shaping is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/trafficShaping/rules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   traffic_shaping_rules
    Should Be Equal As Strings   ${traffic_shaping_rules}[trafficShapingEnabled]   {{ traffic_shaping_rules.traffic_shaping }}

{% else %}
    Skip    traffic_shaping_rules.traffic_shaping_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/traffic_shaping_rules/default_rules_enabled{% if traffic_shaping_rules.default_rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/trafficShaping/rules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   traffic_shaping_rules
    Should Be Equal As Strings   ${traffic_shaping_rules}[defaultRulesEnabled]   {{ traffic_shaping_rules.default_rules}}

{% else %}
    Skip    traffic_shaping_rules.default_rules_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/traffic_shaping_rules/rules{% if traffic_shaping_rules.rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/trafficShaping/rules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   traffic_shaping_rules
    ${evaluated}=    Evaluate    {{ traffic_shaping_rules.rules }}
    ${evaluated}=    Map Application IDs To API    ${evaluated}    path=definitions
    ${validated}=    Validate Subset     ${traffic_shaping_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    traffic_shaping_rules.rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
