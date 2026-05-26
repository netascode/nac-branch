
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set adaptive_policy_policies = organization.adaptive_policy.policies | default(none) %}
Verify Array {{ organization.name }}/adaptive_policy_policies adaptive_policy_policies{% if adaptive_policy_policies is not none %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/policies   ['{{ organization.name }}']   adaptive_policy_policies
    ${evaluated}=    Evaluate    {{ adaptive_policy_policies }}
    ${evaluated}=    Unflatten Dicts In Property    ${evaluated}    prop=acls    add_key=name
    ${validated}=    Validate Subset     ${adaptive_policy_policies}    ${evaluated}     ['source_group.id', 'source_group.name', 'source_group.sgt', 'destination_group.id', 'destination_group.name', 'destination_group.sgt', 'acls', 'last_entry_rule', 'created_at', 'updated_at']
    Should Be True   ${validated}
{% else %}
    Skip   adaptive_policy_policies is not defined
{% endif %}


{% endfor %}
{% endfor %}
