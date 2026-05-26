
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_firewall_one_to_many_nat_rules = network.appliance.firewall.one_to_many_nat_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.firewall.one_to_many_nat_rules{% if appliance_firewall_one_to_many_nat_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/oneToManyNatRules   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_one_to_many_nat_rules
    ${evaluated}=    Evaluate    {{ appliance_firewall_one_to_many_nat_rules }}
    ${validated}=    Validate Subset     ${appliance_firewall_one_to_many_nat_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_firewall_one_to_many_nat_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
