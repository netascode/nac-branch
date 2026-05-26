
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_firewall_cellular_firewall_rules = network.appliance.firewall.cellular_firewall_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_firewall_cellular_firewall_rules/rules{% if appliance_firewall_cellular_firewall_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/cellularFirewallRules   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_cellular_firewall_rules
    ${appliance_firewall_cellular_firewall_rules}=    Filter Out Items By Key    ${appliance_firewall_cellular_firewall_rules}    path=rules    key=comment    values=['Default rule']
    ${evaluated}=    Evaluate    {{ appliance_firewall_cellular_firewall_rules }}
    ${evaluated}=    Assemble Firewall Rules    ${evaluated}    {{ organization.name }}    allow_ipv4_vlans=${True}
    ${validated}=    Validate Subset     ${appliance_firewall_cellular_firewall_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_firewall_cellular_firewall_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
