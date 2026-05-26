
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set wireless_settings = network.wireless.settings | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_settings/meshing_enabled{% if wireless_settings.meshing is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_settings
    Should Be Equal As Strings   ${wireless_settings}[meshingEnabled]   {{ wireless_settings.meshing }}

{% else %}
    Skip    wireless_settings.meshing_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_settings/ipv6_bridge_enabled{% if wireless_settings.ipv6_bridge is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_settings
    Should Be Equal As Strings   ${wireless_settings}[ipv6BridgeEnabled]   {{ wireless_settings.ipv6_bridge }}

{% else %}
    Skip    wireless_settings.ipv6_bridge_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_settings/location_analytics_enabled{% if wireless_settings.location_analytics is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_settings
    Should Be Equal As Strings   ${wireless_settings}[locationAnalyticsEnabled]   {{ wireless_settings.location_analytics }}

{% else %}
    Skip    wireless_settings.location_analytics_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_settings/upgrade_strategy{% if wireless_settings.upgrade_strategy is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_settings
    Should Be Equal As Strings   ${wireless_settings}[upgradeStrategy]   {{ wireless_settings.upgrade_strategy }}

{% else %}
    Skip    wireless_settings.upgrade_strategy is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_settings/led_lights_on{% if wireless_settings.led_lights_on is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_settings
    Should Be Equal As Strings   ${wireless_settings}[ledLightsOn]   {{ wireless_settings.led_lights_on }}

{% else %}
    Skip    wireless_settings.led_lights_on is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_settings/named_vlans_pool_dhcp_monitoring{% if wireless_settings.named_vlans_pool_dhcp_monitoring is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/settings   ['{{ organization.name }}', '{{ network.name }}']   wireless_settings
    ${evaluated}=    Evaluate    {{ wireless_settings.named_vlans_pool_dhcp_monitoring }}
    ${validated}=    Validate Subset     ${wireless_settings}[namedVlans][poolDhcpMonitoring]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_settings.named_vlans_pool_dhcp_monitoring is not defined
{% endif %}
# Note: regulatoryDomain is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.


{% endfor %}
{% endfor %}
{% endfor %}
