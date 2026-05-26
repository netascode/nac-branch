
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set integrations_xdr_networks = organization.integrations.xdr_networks | default(none) %}
Verify {{ organization.name }}/integrations_xdr_networks{% if integrations_xdr_networks is not none %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/integrations/xdr/networks   ['{{ organization.name }}']   integrations_xdr_networks
    ${evaluated}=    Evaluate    {{ integrations_xdr_networks }}
    ${evaluated}=    Rename Property    ${evaluated}    network_name    name
    ${validated}=    Validate Subset     ${integrations_xdr_networks}[items]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    integrations_xdr_networks is not defined
{% endif %}

{% endfor %}
{% endfor %}
