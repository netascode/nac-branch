
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set wireless_bluetooth_settings = network.wireless.bluetooth_settings | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_bluetooth_settings/scanning{% if wireless_bluetooth_settings.scanning is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[scanningEnabled]   {{ wireless_bluetooth_settings.scanning }}

{% else %}
    Skip    wireless_bluetooth_settings.scanning is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_bluetooth_settings/advertising{% if wireless_bluetooth_settings.advertising is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[advertisingEnabled]   {{ wireless_bluetooth_settings.advertising }}

{% else %}
    Skip    wireless_bluetooth_settings.advertising is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_bluetooth_settings/uuid{% if wireless_bluetooth_settings.uuid is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[uuid]   {{ wireless_bluetooth_settings.uuid }}

{% else %}
    Skip    wireless_bluetooth_settings.uuid is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_bluetooth_settings/major_minor_assignment_mode{% if wireless_bluetooth_settings.major_minor_assignment_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[majorMinorAssignmentMode]   {{ wireless_bluetooth_settings.major_minor_assignment_mode }}

{% else %}
    Skip    wireless_bluetooth_settings.major_minor_assignment_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_bluetooth_settings/major{% if wireless_bluetooth_settings.major is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[major]   {{ wireless_bluetooth_settings.major }}

{% else %}
    Skip    wireless_bluetooth_settings.major is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_bluetooth_settings/minor{% if wireless_bluetooth_settings.minor is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/bluetooth/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_bluetooth_settings
    Should Be Equal As Strings   ${wireless_bluetooth_settings}[minor]   {{ wireless_bluetooth_settings.minor }}

{% else %}
    Skip    wireless_bluetooth_settings.minor is not defined
{% endif %}
# Note: eslEnabled is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.


{% endfor %}
{% endfor %}
{% endfor %}
