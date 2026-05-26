
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for policy_objects_group in organization.policy_objects_groups | default([], true) %}

{% if (policy_objects_group.managed | default(true)) == false %}
{{ organization.name }}/policy_objects_groups/{{ policy_objects_group.name }} (unmanaged)
    Skip    policy_objects_group.managed is false
{% else %}

# Note: id is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/policy_objects_groups/{{ policy_objects_group.name }}//name{% if policy_objects_group.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/groups/{policyObjectGroupId}   ['{{ organization.name }}', '{{ policy_objects_group.name }}']   policy_objects_group
    Should Be Equal As Strings   ${policy_objects_group}[name]   {{ policy_objects_group.name }}

{% else %}
    Skip    policy_objects_group.name is not defined
{% endif %}
Verify {{ organization.name }}/policy_objects_groups/{{ policy_objects_group.name }}//category{% if policy_objects_group.category is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/groups/{policyObjectGroupId}   ['{{ organization.name }}', '{{ policy_objects_group.name }}']   policy_objects_group
    Should Be Equal As Strings   ${policy_objects_group}[category]   {{ policy_objects_group.category }}

{% else %}
    Skip    policy_objects_group.category is not defined
{% endif %}
# Note: createdAt is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: updatedAt is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/policy_objects_groups/{{ policy_objects_group.name }}//object_names{% if policy_objects_group.object_names is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/groups/{policyObjectGroupId}   ['{{ organization.name }}', '{{ policy_objects_group.name }}']   policy_objects_group
    ${evaluated}=    Evaluate    {{ policy_objects_group.object_names }}
    ${evaluated}=    Map Names To Ids    ${evaluated}    /organizations/{organizationId}/policyObjects/{policyObjectId}    ['{{ organization.name }}']
    ${validated}=    Validate Subset     ${policy_objects_group}[objectIds]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    policy_objects_group.object_names is not defined
{% endif %}
# Note: networkIds is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.

{% endif %}  {# end managed check #}

{% endfor %}

{% endfor %}
{% endfor %}
