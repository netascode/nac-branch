
*** Settings ***
Library    String
Library    Collections
Library    ../myutils.py

*** Keywords ***
Order Meraki Switch QoS Rules
    [Arguments]    ${switch_qos_rules_order}    ${switch_qos_rules}

    # Create a dictionary to map rule IDs to their original rule details
    ${rules_dict}=    Create Dictionary

    # Populate the dictionary with rule IDs as keys and full rule details as values
    FOR    ${rule}    IN    @{switch_qos_rules}
        Set To Dictionary    ${rules_dict}    ${rule['id']}    ${rule}
    END

    # Create a list to store ordered rules
    @{ordered_rules}=    Create List

    # Iterate through the rule order and fetch corresponding rule details
    FOR    ${rule_id}    IN    @{switch_qos_rules_order}
        ${ordered_rule}=    Get From Dictionary    ${rules_dict}    ${rule_id}
        Append To List    ${ordered_rules}    ${ordered_rule}
    END

    RETURN    ${ordered_rules}

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_qos_rules = network.switch.qos_rules | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_qos_rules_order{% if switch_qos_rules is not none %}
    Get Meraki Data   /networks/{networkId}/switch/qosRules/order   ['{{ organization.name }}', '{{ network.name }}']   switch_qos_rules_order
    Get Meraki Data   /networks/{networkId}/switch/qosRules   ['{{ organization.name }}', '{{ network.name }}']   switch_qos_rules
    ${evaluated}=    Evaluate    {{ switch_qos_rules }}
    ${ordered_rules}=    Order Meraki Switch QoS Rules    ${switch_qos_rules_order}[ruleIds]    ${switch_qos_rules}
    ${evaluated_length}=    Get Length    ${evaluated}
    FOR    ${index}    IN RANGE    ${evaluated_length}
        ${validated}=    Validate Subset     ${ordered_rules}[${index}]      ${evaluated}[${index}]    ['vlan', 'protocol', 'src_port', 'src_port_range', 'dst_port', 'dst_port_range', 'dscp']
        Should Be True    ${validated}
    END
{% else %}
    Skip   switch_qos_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
