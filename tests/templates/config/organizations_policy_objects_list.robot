
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for policy_object in organization.policy_objects | default([], true) %}

{% if (policy_object.managed | default(true)) == false %}
{{ organization.name }}/policy_objects/{{ policy_object.name }} (unmanaged)
    Skip    policy_object.managed is false
{% else %}

# Note: id is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/policy_objects/{{ policy_object.name }}//name{% if policy_object.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/{policyObjectId}   ['{{ organization.name }}', '{{ policy_object.name }}']   policy_object
    Should Be Equal As Strings   ${policy_object}[name]   {{ policy_object.name }}

{% else %}
    Skip    policy_object.name is not defined
{% endif %}
Verify {{ organization.name }}/policy_objects/{{ policy_object.name }}//category{% if policy_object.category is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/{policyObjectId}   ['{{ organization.name }}', '{{ policy_object.name }}']   policy_object
    Should Be Equal As Strings   ${policy_object}[category]   {{ policy_object.category }}

{% else %}
    Skip    policy_object.category is not defined
{% endif %}
Verify {{ organization.name }}/policy_objects/{{ policy_object.name }}//type{% if policy_object.type is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/{policyObjectId}   ['{{ organization.name }}', '{{ policy_object.name }}']   policy_object
    Should Be Equal As Strings   ${policy_object}[type]   {{ policy_object.type }}

{% else %}
    Skip    policy_object.type is not defined
{% endif %}
Verify {{ organization.name }}/policy_objects/{{ policy_object.name }}//cidr{% if policy_object.cidr is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/{policyObjectId}   ['{{ organization.name }}', '{{ policy_object.name }}']   policy_object
    Should Be Equal As Strings   ${policy_object}[cidr]   {{ policy_object.cidr }}

{% else %}
    Skip    policy_object.cidr is not defined
{% endif %}
# Note: createdAt is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: updatedAt is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/policy_objects/{{ policy_object.name }}//group_ids{% if policy_object.group_ids is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/{policyObjectId}   ['{{ organization.name }}', '{{ policy_object.name }}']   policy_object
    ${evaluated}=    Evaluate    {{ policy_object.group_ids }}
    ${validated}=    Validate Subset     ${policy_object}[groupIds]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    policy_object.group_ids is not defined
{% endif %}
Verify {{ organization.name }}/policy_objects/{{ policy_object.name }}//network_ids{% if policy_object.network_ids is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/policyObjects/{policyObjectId}   ['{{ organization.name }}', '{{ policy_object.name }}']   policy_object
    ${evaluated}=    Evaluate    {{ policy_object.network_ids }}
    ${validated}=    Validate Subset     ${policy_object}[networkIds]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    policy_object.network_ids is not defined
{% endif %}

{% endif %}  {# end managed check #}

{% endfor %}

{% endfor %}
{% endfor %}
