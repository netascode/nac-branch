
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

# Note: id is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}//name{% if organization.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}   ['{{ organization.name }}']   organization
    Should Be Equal As Strings   ${organization}[name]   {{ organization.name }}

{% else %}
    Skip    organization.name is not defined
{% endif %}
# Note: url is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: api is not checked, as it is only included in the response (and PUT request),
#       but not in the OpenAPI POST request, hence not in the .nac.yaml schema.
# Note: licensing is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: cloud is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}//management{% if organization.management is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}   ['{{ organization.name }}']   organization
    ${evaluated}=    Evaluate    {{ organization.management }}
    ${evaluated}=    Unflatten Dicts    ${evaluated}    add_key=details
    ${validated}=    Validate Subset     ${organization}[management]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    organization.management is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
