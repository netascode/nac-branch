
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for early_access_features_opt_in in organization.early_access_features_opt_ins | default([], true) %}
# Note: id is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/early_access_features_opt_ins/{{ early_access_features_opt_in.short_name }}//short_name{% if early_access_features_opt_in.short_name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/earlyAccess/features/optIns/{optInId}   ['{{ organization.name }}', '{{ early_access_features_opt_in.short_name }}']   early_access_features_opt_in
    Should Be Equal As Strings   ${early_access_features_opt_in}[shortName]   {{ early_access_features_opt_in.short_name }}

{% else %}
    Skip    early_access_features_opt_in.short_name is not defined
{% endif %}
Verify {{ organization.name }}/early_access_features_opt_ins/{{ early_access_features_opt_in.short_name }}//limit_scope_to_networks{% if early_access_features_opt_in.limit_scope_to_networks is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/earlyAccess/features/optIns/{optInId}   ['{{ organization.name }}', '{{ early_access_features_opt_in.short_name }}']   early_access_features_opt_in
    ${evaluated}=    Evaluate    {{ early_access_features_opt_in.limit_scope_to_networks }}
    ${evaluated}=    Unflatten Dicts    ${evaluated}    add_key=name
    ${validated}=    Validate Subset     ${early_access_features_opt_in}[limitScopeToNetworks]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    early_access_features_opt_in.limit_scope_to_networks is not defined
{% endif %}
# Note: optOutEligibility is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: createdAt is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.

{% endfor %}

{% endfor %}
{% endfor %}
