
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for admin in organization.admins | default([], true) %}
Verify {{ organization.name }}/admins/{{ admin.name }}//name{% if admin.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/admins   ['{{ organization.name }}']   admins
    ${admin}=    Get List Item By Key    ${admins}    key=name    value={{ admin.name }}
    Should Be Equal As Strings   ${admin}[name]   {{ admin.name }}

{% else %}
    Skip    admin.name is not defined
{% endif %}
Verify {{ organization.name }}/admins/{{ admin.name }}//organization_access{% if admin.organization_access is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/admins   ['{{ organization.name }}']   admins
    ${admin}=    Get List Item By Key    ${admins}    key=name    value={{ admin.name }}
    Should Be Equal As Strings   ${admin}[orgAccess]   {{ admin.organization_access }}

{% else %}
    Skip    admin.organization_access is not defined
{% endif %}
Verify {{ organization.name }}/admins/{{ admin.name }}//tags{% if admin.tags is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/admins   ['{{ organization.name }}']   admins
    ${admin}=    Get List Item By Key    ${admins}    key=name    value={{ admin.name }}
    ${evaluated}=    Evaluate    {{ admin.tags }}
    ${validated}=    Validate Subset     ${admin}[tags]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    admin.tags is not defined
{% endif %}
Verify {{ organization.name }}/admins/{{ admin.name }}//networks{% if admin.networks is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/admins   ['{{ organization.name }}']   admins
    ${admin}=    Get List Item By Key    ${admins}    key=name    value={{ admin.name }}
    ${evaluated}=    Evaluate    {{ admin.networks }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}    ['{{ organization.name }}']    name_prop=name    id_prop=id
    ${validated}=    Validate Subset     ${admin}[networks]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    admin.networks is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
