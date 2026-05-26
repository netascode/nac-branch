*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set firewall_l7_firewall_rules = wireless_ssid.firewall_l7_firewall_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_ssids/{{ wireless_ssid.name }}/firewall_l7_firewall_rules{% if firewall_l7_firewall_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/firewall/l7FirewallRules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   firewall_l7_firewall_rules
    ${evaluated}=    Evaluate    {{ firewall_l7_firewall_rules }}
    ${evaluated}=    Map Application IDs To API    ${evaluated}
    ${validated}=    Validate Subset     ${firewall_l7_firewall_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    firewall_l7_firewall_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
