
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_access_control_lists_rules = network.switch.access_control_lists_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch.access_control_lists_rules{% if switch_access_control_lists_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessControlLists   ['{{ organization.name }}', '{{ network.name }}']   switch_access_control_lists
    ${switch_access_control_lists}=    Filter Out Items By Key    ${switch_access_control_lists}    path=rules    key=comment    values=['Default rule']
    ${evaluated}=    Evaluate    {{ switch_access_control_lists_rules }}
    ${validated}=    Validate Subset     ${switch_access_control_lists}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_control_lists_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
