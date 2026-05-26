
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_settings = network.switch.settings | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_settings/vlan{% if switch_settings.vlan is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/settings   ['{{ organization.name }}', '{{ network.name }}']   switch_settings
    Should Be Equal As Strings   ${switch_settings}[vlan]   {{ switch_settings.vlan }}

{% else %}
    Skip    switch_settings.vlan is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_settings/use_combined_power{% if switch_settings.use_combined_power is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/settings   ['{{ organization.name }}', '{{ network.name }}']   switch_settings
    Should Be Equal As Strings   ${switch_settings}[useCombinedPower]   {{ switch_settings.use_combined_power }}

{% else %}
    Skip    switch_settings.use_combined_power is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_settings/power_exceptions{% if switch_settings.power_exceptions is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/settings   ['{{ organization.name }}', '{{ network.name }}']   switch_settings
    ${evaluated}=    Evaluate    {{ switch_settings.power_exceptions }}
    ${validated}=    Validate Subset     ${switch_settings}[powerExceptions]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_settings.power_exceptions is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_settings/uplink_client_sampling{% if switch_settings.uplink_client_sampling is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/settings   ['{{ organization.name }}', '{{ network.name }}']   switch_settings
    Should Be Equal As Strings   ${switch_settings}[uplinkClientSampling][enabled]   {{ switch_settings.uplink_client_sampling }}

{% else %}
    Skip    switch_settings.uplink_client_sampling is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_settings/mac_blocklist{% if switch_settings.mac_blocklist is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/settings   ['{{ organization.name }}', '{{ network.name }}']   switch_settings
    Should Be Equal As Strings   ${switch_settings}[macBlocklist][enabled]   {{ switch_settings.mac_blocklist }}

{% else %}
    Skip    switch_settings.mac_blocklist is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
