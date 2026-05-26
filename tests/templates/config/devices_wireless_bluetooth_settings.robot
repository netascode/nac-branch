
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.wireless is defined %}
{% set wireless_bluetooth_settings = device.wireless.bluetooth_settings | default({}, true) %}
Verify {{ organization.name }}/devices/{{ device.name }}/wireless.bluetooth_settings/uuid{% if wireless_bluetooth_settings.uuid is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ device.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[uuid]   {{ wireless_bluetooth_settings.uuid }}

{% else %}
    Skip    wireless_bluetooth_settings.uuid is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/wireless.bluetooth_settings/major{% if wireless_bluetooth_settings.major is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ device.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[major]   {{ wireless_bluetooth_settings.major }}

{% else %}
    Skip    wireless_bluetooth_settings.major is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/wireless.bluetooth_settings/minor{% if wireless_bluetooth_settings.minor is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ device.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[minor]   {{ wireless_bluetooth_settings.minor }}

{% else %}
    Skip    wireless_bluetooth_settings.minor is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
