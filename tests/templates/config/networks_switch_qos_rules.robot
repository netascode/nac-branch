
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_qos_rules = network.switch.qos_rules | default(none) %}
Verify Array {{ organization.name }}/networks/{{ network.name }}/switch_qos_rules switch_qos_rules{% if switch_qos_rules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/qosRules   ['{{ organization.name }}', '{{ network.name }}']   switch_qos_rules
    ${evaluated}=    Evaluate    {{ switch_qos_rules }}
    ${validated}=    Validate Subset     ${switch_qos_rules}    ${evaluated}     ['id', 'vlan', 'protocol', 'src_port', 'src_port_range', 'dst_port', 'dst_port_range', 'dscp']
    Should Be True   ${validated}
{% else %}
    Skip   switch_qos_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
