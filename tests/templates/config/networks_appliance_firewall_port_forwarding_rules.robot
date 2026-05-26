
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_firewall_port_forwarding_rules = network.appliance.firewall.port_forwarding_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_firewall_port_forwarding_rules/rules{% if appliance_firewall_port_forwarding_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/portForwardingRules   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_port_forwarding_rules
    ${evaluated}=    Evaluate    {{ appliance_firewall_port_forwarding_rules }}
    ${validated}=    Validate Subset     ${appliance_firewall_port_forwarding_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_firewall_port_forwarding_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
