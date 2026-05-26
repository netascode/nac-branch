
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.wireless is defined %}
{% set wireless_radio_settings = device.wireless.radio_settings | default({}, true) %}

Verify {{ organization.name }}/devices/{{ device.name }}/wireless_radio_settings/rf_profile_name{% if wireless_radio_settings.rf_profile_name is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/wireless/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   wireless_radio_settings
    ${evaluated}=    Set Variable    {{ wireless_radio_settings.rf_profile_name }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}/wireless/rfProfiles/{rfProfileId}    ['{{ organization.name }}', '{{ network.name }}']
    Should Be Equal As Strings   ${wireless_radio_settings}[rfProfileId]   ${evaluated}

{% else %}
    Skip    wireless_radio_settings.rf_profile_name is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/wireless.radio_settings.two_four_ghz_settings{% if wireless_radio_settings.two_four_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/wireless/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   wireless_radio_settings
    ${evaluated}=    Evaluate    {{ wireless_radio_settings.two_four_ghz_settings }}
    ${validated}=    Validate Subset     ${wireless_radio_settings}[twoFourGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_radio_settings.two_four_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/wireless.radio_settings.five_ghz_settings{% if wireless_radio_settings.five_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/wireless/radio/settings   ['{{ organization.name }}', '{{ device.name }}']   wireless_radio_settings
    ${evaluated}=    Evaluate    {{ wireless_radio_settings.five_ghz_settings }}
    ${validated}=    Validate Subset     ${wireless_radio_settings}[fiveGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_radio_settings.five_ghz_settings is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
