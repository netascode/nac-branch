
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//number{% if wireless_ssid.ssid_number is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[number]   {{ wireless_ssid.ssid_number }}

{% else %}
    Skip    wireless_ssid.ssid_number is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//name{% if wireless_ssid.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[name]   {{ wireless_ssid.name }}

{% else %}
    Skip    wireless_ssid.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//enabled{% if wireless_ssid.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[enabled]   {{ wireless_ssid.enabled }}

{% else %}
    Skip    wireless_ssid.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//splash_page{% if wireless_ssid.splash_page is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[splashPage]   {{ wireless_ssid.splash_page }}

{% else %}
    Skip    wireless_ssid.splash_page is not defined
{% endif %}
# Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//ssid_admin_accessible{% if wireless_ssid.ssid_admin_accessible is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
#     Should Be Equal As Strings   ${wireless_ssid}[ssidAdminAccessible]   {{ wireless_ssid.ssid_admin_accessible }}

# {% else %}
#     Skip    wireless_ssid.ssid_admin_accessible is not defined
# {% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//local_auth{% if wireless_ssid.local_auth is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[localAuth]   {{ wireless_ssid.local_auth }}

{% else %}
    Skip    wireless_ssid.local_auth is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//auth_mode{% if wireless_ssid.auth_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[authMode]   {{ wireless_ssid.auth_mode }}

{% else %}
    Skip    wireless_ssid.auth_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//encryption_mode{% if wireless_ssid.encryption_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[encryptionMode]   {{ wireless_ssid.encryption_mode }}

{% else %}
    Skip    wireless_ssid.encryption_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//wpa_encryption_mode{% if wireless_ssid.wpa_encryption_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[wpaEncryptionMode]   {{ wireless_ssid.wpa_encryption_mode }}

{% else %}
    Skip    wireless_ssid.wpa_encryption_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//radius.servers{% if wireless_ssid.radius.servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    ${evaluated}=    Evaluate    {{ wireless_ssid.radius.servers }}
    ${validated}=    Validate Subset     ${wireless_ssid}[radiusServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_ssid.radius.servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//radius.accounting_servers{% if wireless_ssid.radius.accounting_servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    ${evaluated}=    Evaluate    {{ wireless_ssid.radius.accounting_servers }}
    ${validated}=    Validate Subset     ${wireless_ssid}[radiusAccountingServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_ssid.radius.accounting_servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//radius.accounting{% if wireless_ssid.radius.accounting is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[radiusAccountingEnabled]   {{ wireless_ssid.radius.accounting }}

{% else %}
    Skip    wireless_ssid.radius.accounting is not defined
{% endif %}
# Note: radiusEnabled is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//radius.attribute_for_group_policies{% if wireless_ssid.radius.attribute_for_group_policies is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[radiusAttributeForGroupPolicies]   {{ wireless_ssid.radius.attribute_for_group_policies }}

{% else %}
    Skip    wireless_ssid.radius.attribute_for_group_policies is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//radius.failover_policy{% if wireless_ssid.radius.failover_policy is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[radiusFailoverPolicy]   {{ wireless_ssid.radius.failover_policy }}

{% else %}
    Skip    wireless_ssid.radius.failover_policy is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//radius.load_balancing_policy{% if wireless_ssid.radius.load_balancing_policy is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[radiusLoadBalancingPolicy]   {{ wireless_ssid.radius.load_balancing_policy }}

{% else %}
    Skip    wireless_ssid.radius.load_balancing_policy is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//ip_assignment_mode{% if wireless_ssid.ip_assignment_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[ipAssignmentMode]   {{ wireless_ssid.ip_assignment_mode }}

{% else %}
    Skip    wireless_ssid.ip_assignment_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//admin_splash_url{% if wireless_ssid.admin_splash_url is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[adminSplashUrl]   {{ wireless_ssid.admin_splash_url }}

{% else %}
    Skip    wireless_ssid.admin_splash_url is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//splash_timeout{% if wireless_ssid.splash_timeout is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[splashTimeout]   {{ wireless_ssid.splash_timeout }}

{% else %}
    Skip    wireless_ssid.splash_timeout is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//walled_garden{% if wireless_ssid.walled_garden is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[walledGardenEnabled]   {{ wireless_ssid.walled_garden }}

{% else %}
    Skip    wireless_ssid.walled_garden is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//walled_garden_ranges{% if wireless_ssid.walled_garden_ranges is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    ${evaluated}=    Evaluate    {{ wireless_ssid.walled_garden_ranges }}
    ${validated}=    Validate Subset     ${wireless_ssid}[walledGardenRanges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_ssid.walled_garden_ranges is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//min_bitrate{% if wireless_ssid.min_bitrate is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[minBitrate]   {{ wireless_ssid.min_bitrate }}

{% else %}
    Skip    wireless_ssid.min_bitrate is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//band_selection{% if wireless_ssid.band_selection is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[bandSelection]   {{ wireless_ssid.band_selection }}

{% else %}
    Skip    wireless_ssid.band_selection is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//per_client_bandwidth_limit_up{% if wireless_ssid.per_client_bandwidth_limit_up is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[perClientBandwidthLimitUp]   {{ wireless_ssid.per_client_bandwidth_limit_up }}

{% else %}
    Skip    wireless_ssid.per_client_bandwidth_limit_up is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//per_client_bandwidth_limit_down{% if wireless_ssid.per_client_bandwidth_limit_down is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[perClientBandwidthLimitDown]   {{ wireless_ssid.per_client_bandwidth_limit_down }}

{% else %}
    Skip    wireless_ssid.per_client_bandwidth_limit_down is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//visible{% if wireless_ssid.visible is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[visible]   {{ wireless_ssid.visible }}

{% else %}
    Skip    wireless_ssid.visible is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//available_on_all_aps{% if wireless_ssid.available_on_all_aps is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[availableOnAllAps]   {{ wireless_ssid.available_on_all_aps }}

{% else %}
    Skip    wireless_ssid.available_on_all_aps is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//availability_tags{% if wireless_ssid.availability_tags is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    ${evaluated}=    Evaluate    {{ wireless_ssid.availability_tags }}
    ${validated}=    Validate Subset     ${wireless_ssid}[availabilityTags]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_ssid.availability_tags is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//per_ssid_bandwidth_limit_up{% if wireless_ssid.per_ssid_bandwidth_limit_up is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[perSsidBandwidthLimitUp]   {{ wireless_ssid.per_ssid_bandwidth_limit_up }}

{% else %}
    Skip    wireless_ssid.per_ssid_bandwidth_limit_up is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//per_ssid_bandwidth_limit_down{% if wireless_ssid.per_ssid_bandwidth_limit_down is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[perSsidBandwidthLimitDown]   {{ wireless_ssid.per_ssid_bandwidth_limit_down }}

{% else %}
    Skip    wireless_ssid.per_ssid_bandwidth_limit_down is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}//mandatory_dhcp{% if wireless_ssid.mandatory_dhcp is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   wireless_ssid
    Should Be Equal As Strings   ${wireless_ssid}[mandatoryDhcpEnabled]   {{ wireless_ssid.mandatory_dhcp }}

{% else %}
    Skip    wireless_ssid.mandatory_dhcp is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
