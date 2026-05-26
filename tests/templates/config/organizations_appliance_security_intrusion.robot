
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set appliance_security_intrusion_allowed_rules = organization.appliance.security_intrusion_allowed_rules | default(none) %}
Verify {{ organization.name }}/appliance.security_intrusion_allowed_rules{% if appliance_security_intrusion_allowed_rules is not none %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/security/intrusion   ['{{ organization.name }}']   appliance_security_intrusion
    ${evaluated}=    Evaluate    {{ appliance_security_intrusion_allowed_rules }}
    ${validated}=    Validate Subset     ${appliance_security_intrusion}[allowedRules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.security_intrusion_allowed_rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
