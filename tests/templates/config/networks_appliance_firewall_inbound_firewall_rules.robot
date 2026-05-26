*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_firewall_inbound_firewall_rules = network.appliance.firewall.inbound_firewall_rules | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.firewall.inbound_firewall_rules.rules{% if appliance_firewall_inbound_firewall_rules.rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/inboundFirewallRules   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_inbound_firewall_rules
    ${appliance_firewall_inbound_firewall_rules}=    Filter Out Items By Key    ${appliance_firewall_inbound_firewall_rules}    path=rules    key=comment    values=['Default rule']
    ${evaluated}=    Evaluate    {{ appliance_firewall_inbound_firewall_rules.rules }}
    ${evaluated}=    Assemble Firewall Rules    ${evaluated}    {{ organization.name }}    allow_ipv4_vlans=${False}
    ${validated}=    Validate Subset     ${appliance_firewall_inbound_firewall_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_firewall_inbound_firewall_rules.rules is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.firewall.inbound_firewall_rules.syslog_default_rule{% if appliance_firewall_inbound_firewall_rules.syslog_default_rule is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/inboundFirewallRules   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_inbound_firewall_rules
    Should Be Equal As Strings   ${appliance_firewall_inbound_firewall_rules}[syslogDefaultRule]   {{ appliance_firewall_inbound_firewall_rules.syslog_default_rule }}

{% else %}
    Skip    appliance_firewall_inbound_firewall_rules.syslog_default_rule is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}