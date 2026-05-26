
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_security_intrusion = network.appliance.security_intrusion | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.security_intrusion/mode{% if appliance_security_intrusion.mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/security/intrusion   ['{{ organization.name }}', '{{ network.name }}']   appliance_security_intrusion
    Should Be Equal As Strings   ${appliance_security_intrusion}[mode]   {{ appliance_security_intrusion.mode }}

{% else %}
    Skip    appliance.security_intrusion.mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.security_intrusion/ids_rulesets{% if appliance_security_intrusion.ids_rulesets is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/security/intrusion   ['{{ organization.name }}', '{{ network.name }}']   appliance_security_intrusion
    Should Be Equal As Strings   ${appliance_security_intrusion}[idsRulesets]   {{ appliance_security_intrusion.ids_rulesets }}

{% else %}
    Skip    appliance.security_intrusion.ids_rulesets is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.security_intrusion/protected_networks{% if appliance_security_intrusion.protected_networks is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/security/intrusion   ['{{ organization.name }}', '{{ network.name }}']   appliance_security_intrusion
    ${evaluated}=    Evaluate    {{ appliance_security_intrusion.protected_networks }}
    ${validated}=    Validate Subset     ${appliance_security_intrusion}[protectedNetworks]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.security_intrusion.protected_networks is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
