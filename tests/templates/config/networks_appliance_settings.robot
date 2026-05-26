
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_settings = network.appliance.settings | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_settings/client_tracking_method{% if appliance_settings.client_tracking_method is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/settings   ['{{ organization.name }}', '{{ network.name }}']   appliance_settings
    Should Be Equal As Strings   ${appliance_settings}[clientTrackingMethod]   {{ appliance_settings.client_tracking_method }}

{% else %}
    Skip    appliance_settings.client_tracking_method is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_settings/deployment_mode{% if appliance_settings.deployment_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/settings   ['{{ organization.name }}', '{{ network.name }}']   appliance_settings
    Should Be Equal As Strings   ${appliance_settings}[deploymentMode]   {{ appliance_settings.deployment_mode }}

{% else %}
    Skip    appliance_settings.deployment_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_settings/dynamic_dns{% if appliance_settings.dynamic_dns is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/settings   ['{{ organization.name }}', '{{ network.name }}']   appliance_settings
    ${evaluated}=    Evaluate    {{ appliance_settings.dynamic_dns }}
    ${validated}=    Validate Subset     ${appliance_settings}[dynamicDns]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_settings.dynamic_dns is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
