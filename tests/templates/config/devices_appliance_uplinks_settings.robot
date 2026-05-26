
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.appliance is defined %}
{% set appliance_uplinks_settings = device.appliance.uplinks_settings | default({}, true) %}
Verify {{ organization.name }}/devices/{{ device.name }}/appliance.uplinks_settings/wan1{% if appliance_uplinks_settings.wan1 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/appliance/uplinks/settings   ['{{ organization.name }}', '{{ device.name }}']   appliance_uplinks_settings
    ${evaluated}=    Evaluate    {{ appliance_uplinks_settings.wan1 }}
    ${evaluated}=    Unflatten Dict   ${evaluated}   add_key=addresses   path=svis.ipv4.nameservers
    ${evaluated}=    Unflatten Dict   ${evaluated}   add_key=addresses   path=svis.ipv6.nameservers
    ${validated}=    Validate Subset     ${appliance_uplinks_settings}[interfaces][wan1]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_uplinks_settings.wan1 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/appliance.uplinks_settings/wan2{% if appliance_uplinks_settings.wan2 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/appliance/uplinks/settings   ['{{ organization.name }}', '{{ device.name }}']   appliance_uplinks_settings
    ${evaluated}=    Evaluate    {{ appliance_uplinks_settings.wan2 }}
    ${evaluated}=    Unflatten Dict   ${evaluated}   add_key=addresses   path=svis.ipv4.nameservers
    ${evaluated}=    Unflatten Dict   ${evaluated}   add_key=addresses   path=svis.ipv6.nameservers
    ${validated}=    Validate Subset     ${appliance_uplinks_settings}[interfaces][wan2]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_uplinks_settings.wan2 is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
