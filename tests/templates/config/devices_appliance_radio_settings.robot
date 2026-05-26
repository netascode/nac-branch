
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.appliance is defined %}
{% set appliance_radio_settings = device.appliance.radio_settings | default({}, true) %}
Verify {{ organization.name }}/devices/{{ device.name }}/appliance_radio_settings/serial{% if appliance_radio_settings.serial is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/appliance/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   appliance_radio_settings
    Should Be Equal As Strings   ${appliance_radio_settings}[serial]   {{ appliance_radio_settings.serial }}

{% else %}
    Skip    appliance_radio_settings.serial is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/appliance_radio_settings/rf_profile_id{% if appliance_radio_settings.rf_profile_id is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/appliance/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   appliance_radio_settings
    Should Be Equal As Strings   ${appliance_radio_settings}[rfProfileId]   {{ appliance_radio_settings.rf_profile_id }}

{% else %}
    Skip    appliance_radio_settings.rf_profile_id is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/appliance_radio_settings/two_four_ghz_settings{% if appliance_radio_settings.two_four_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/appliance/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   appliance_radio_settings
    ${evaluated}=    Evaluate    {{ appliance_radio_settings.two_four_ghz_settings }}
    ${validated}=    Validate Subset     ${appliance_radio_settings}[twoFourGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_radio_settings.two_four_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/appliance_radio_settings/five_ghz_settings{% if appliance_radio_settings.five_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/appliance/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   appliance_radio_settings
    ${evaluated}=    Evaluate    {{ appliance_radio_settings.five_ghz_settings }}
    ${validated}=    Validate Subset     ${appliance_radio_settings}[fiveGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_radio_settings.five_ghz_settings is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
