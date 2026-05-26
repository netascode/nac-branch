
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for adaptive_policy_acl in organization.adaptive_policy.acls | default([], true) %}
# Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//acl_id{% if adaptive_policy_acl.acl_id is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
#     Should Be Equal As Strings   ${adaptive_policy_acl}[aclId]   {{ adaptive_policy_acl.acl_id }}

# {% else %}
#     Skip    adaptive_policy_acl.acl_id is not defined
# {% endif %}

Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//name{% if adaptive_policy_acl.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
    Should Be Equal As Strings   ${adaptive_policy_acl}[name]   {{ adaptive_policy_acl.name }}

{% else %}
    Skip    adaptive_policy_acl.name is not defined
{% endif %}
Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//description{% if adaptive_policy_acl.description is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
    Should Be Equal As Strings   ${adaptive_policy_acl}[description]   {{ adaptive_policy_acl.description }}

{% else %}
    Skip    adaptive_policy_acl.description is not defined
{% endif %}
Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//ip_version{% if adaptive_policy_acl.ip_version is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
    Should Be Equal As Strings   ${adaptive_policy_acl}[ipVersion]   {{ adaptive_policy_acl.ip_version }}

{% else %}
    Skip    adaptive_policy_acl.ip_version is not defined
{% endif %}
Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//rules{% if adaptive_policy_acl.rules is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
    ${evaluated}=    Evaluate    {{ adaptive_policy_acl.rules }}
    ${validated}=    Validate Subset     ${adaptive_policy_acl}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    adaptive_policy_acl.rules is not defined
{% endif %}
# Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//created_at{% if adaptive_policy_acl.created_at is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
#     Should Be Equal As Strings   ${adaptive_policy_acl}[createdAt]   {{ adaptive_policy_acl.created_at }}

# {% else %}
#     Skip    adaptive_policy_acl.created_at is not defined
# {% endif %}
# Verify {{ organization.name }}/adaptive_policy_acls/{{ adaptive_policy_acl.name }}//updated_at{% if adaptive_policy_acl.updated_at is defined %}
#     [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/acls/{aclId}   ['{{ organization.name }}', '{{ adaptive_policy_acl.name }}']   adaptive_policy_acl
#     Should Be Equal As Strings   ${adaptive_policy_acl}[updatedAt]   {{ adaptive_policy_acl.updated_at }}

# {% else %}
#     Skip    adaptive_policy_acl.updated_at is not defined
# {% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
