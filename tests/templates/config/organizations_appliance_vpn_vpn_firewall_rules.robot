
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set appliance_vpn_firewall_rules = organization.appliance.vpn_firewall_rules | default({}, true) %}
Verify {{ organization.name }}/appliance_vpn_firewall_rules/rules{% if appliance_vpn_firewall_rules.rules is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/vpn/vpnFirewallRules   ['{{ organization.name }}']   appliance_vpn_firewall_rules
    ${appliance_vpn_firewall_rules}=    Filter Out Items By Key    ${appliance_vpn_firewall_rules}    path=rules    key=comment    values=['Default rule']
    ${evaluated}=    Evaluate    {{ appliance_vpn_firewall_rules.rules }}
    ${validated}=    Validate Subset     ${appliance_vpn_firewall_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vpn_firewall_rules.rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
