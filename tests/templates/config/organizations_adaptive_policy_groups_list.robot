
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for adaptive_policy_group in organization.adaptive_policy.groups | default([], true) %}

{% if (adaptive_policy_group.managed | default(true)) == false %}
{{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }} (unmanaged)
    Skip    adaptive_policy_group.managed is false
{% else %}

# Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//group_id{% if adaptive_policy_group.group_id is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
#     Should Be Equal As Strings   ${adaptive_policy_group}[groupId]   {{ adaptive_policy_group.group_id }}

# {% else %}
#     Skip    adaptive_policy_group.group_id is not defined
# {% endif %}

Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//name{% if adaptive_policy_group.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
    Should Be Equal As Strings   ${adaptive_policy_group}[name]   {{ adaptive_policy_group.name }}

{% else %}
    Skip    adaptive_policy_group.name is not defined
{% endif %}
Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//sgt{% if adaptive_policy_group.sgt is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
    Should Be Equal As Strings   ${adaptive_policy_group}[sgt]   {{ adaptive_policy_group.sgt }}

{% else %}
    Skip    adaptive_policy_group.sgt is not defined
{% endif %}
Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//description{% if adaptive_policy_group.description is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
    Should Be Equal As Strings   ${adaptive_policy_group}[description]   {{ adaptive_policy_group.description }}

{% else %}
    Skip    adaptive_policy_group.description is not defined
{% endif %}
Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//policy_objects{% if adaptive_policy_group.policy_objects is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
    ${evaluated}=    Evaluate    {{ adaptive_policy_group.policy_objects }}
    ${evaluated}=    Unflatten Dicts    ${evaluated}    add_key=name
    ${validated}=    Validate Subset     ${adaptive_policy_group}[policyObjects]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    adaptive_policy_group.policy_objects is not defined
{% endif %}
# Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//is_default_group{% if adaptive_policy_group.is_default_group is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
#     Should Be Equal As Strings   ${adaptive_policy_group}[isDefaultGroup]   {{ adaptive_policy_group.is_default_group }}

# {% else %}
#     Skip    adaptive_policy_group.is_default_group is not defined
# {% endif %}
# Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//required_ip_mappings{% if adaptive_policy_group.required_ip_mappings is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
#     ${evaluated}=    Evaluate    {{ adaptive_policy_group.required_ip_mappings }}
#     ${validated}=    Validate Subset     ${adaptive_policy_group}[requiredIpMappings]    ${evaluated}
#     Should Be True   ${validated}

# {% else %}
#     Skip    adaptive_policy_group.required_ip_mappings is not defined
# {% endif %}
# Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//created_at{% if adaptive_policy_group.created_at is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
#     Should Be Equal As Strings   ${adaptive_policy_group}[createdAt]   {{ adaptive_policy_group.created_at }}

# {% else %}
#     Skip    adaptive_policy_group.created_at is not defined
# {% endif %}
# Verify {{ organization.name }}/adaptive_policy_groups/{{ adaptive_policy_group.name }}//updated_at{% if adaptive_policy_group.updated_at is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/groups/{id}   ['{{ organization.name }}', '{{ adaptive_policy_group.name }}']   adaptive_policy_group
#     Should Be Equal As Strings   ${adaptive_policy_group}[updatedAt]   {{ adaptive_policy_group.updated_at }}

# {% else %}
#     Skip    adaptive_policy_group.updated_at is not defined
# {% endif %}

{% endif %}  {# end managed check #}

{% endfor %}

{% endfor %}
{% endfor %}
