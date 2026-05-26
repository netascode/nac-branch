
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_firewall_l7_firewall_rules = network.appliance.firewall.l7_firewall_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.firewall.l7_firewall_rules/rules{% if appliance_firewall_l7_firewall_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/l7FirewallRules   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_l7_firewall_rules
    ${evaluated}=    Evaluate    {{ appliance_firewall_l7_firewall_rules }}
    ${evaluated}=    Map Application IDs To API    ${evaluated}
    ${evaluated}=    Map Country IDs To API    ${evaluated}
    ${validated}=    Validate Subset     ${appliance_firewall_l7_firewall_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.firewall.l7_firewall_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
