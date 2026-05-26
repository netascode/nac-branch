
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set firewall_l3_firewall_rules = wireless_ssid.firewall_l3_firewall_rules | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/firewall_l3_firewall_rules/rules{% if firewall_l3_firewall_rules.rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/firewall/l3FirewallRules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   firewall_l3_firewall_rules
    ${firewall_l3_firewall_rules}=    Filter Out Items By Key    ${firewall_l3_firewall_rules}    path=rules    key=comment    values=['Default rule', 'Wireless clients accessing LAN']
    ${evaluated}=    Evaluate    {{ firewall_l3_firewall_rules.rules }}
    ${validated}=    Validate Subset     ${firewall_l3_firewall_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    firewall_l3_firewall_rules.rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
