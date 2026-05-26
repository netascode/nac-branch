
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set adaptive_policy = organization.adaptive_policy | default({}, true) %}
Verify {{ organization.name }}/adaptive_policy.settings_enabled_networks{% if adaptive_policy.settings_enabled_networks is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/adaptivePolicy/settings   ['{{ organization.name }}']   adaptive_policy_settings
    ${evaluated}=    Evaluate    {{ adaptive_policy.settings_enabled_networks }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}    ['{{ organization.name }}']
    ${validated}=    Validate Subset     ${adaptive_policy_settings}[enabledNetworks]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    adaptive_policy.settings_enabled_networks is not defined
{% endif %}


{% endfor %}
{% endfor %}
