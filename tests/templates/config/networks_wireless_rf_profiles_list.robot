
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_rf_profile in network.wireless_rf_profiles | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//id{% if wireless_rf_profile.id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    Should Be Equal As Strings   ${wireless_rf_profile}[id]   {{ wireless_rf_profile.id }}

{% else %}
    Skip    wireless_rf_profile.id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//network_id{% if wireless_rf_profile.network_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    Should Be Equal As Strings   ${wireless_rf_profile}[networkId]   {{ wireless_rf_profile.network_id }}

{% else %}
    Skip    wireless_rf_profile.network_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//name{% if wireless_rf_profile.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    Should Be Equal As Strings   ${wireless_rf_profile}[name]   {{ wireless_rf_profile.name }}

{% else %}
    Skip    wireless_rf_profile.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//client_balancing_enabled{% if wireless_rf_profile.client_balancing_enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    Should Be Equal As Strings   ${wireless_rf_profile}[clientBalancingEnabled]   {{ wireless_rf_profile.client_balancing_enabled }}

{% else %}
    Skip    wireless_rf_profile.client_balancing_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//min_bitrate_type{% if wireless_rf_profile.min_bitrate_type is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    Should Be Equal As Strings   ${wireless_rf_profile}[minBitrateType]   {{ wireless_rf_profile.min_bitrate_type }}

{% else %}
    Skip    wireless_rf_profile.min_bitrate_type is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//band_selection_type{% if wireless_rf_profile.band_selection_type is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    Should Be Equal As Strings   ${wireless_rf_profile}[bandSelectionType]   {{ wireless_rf_profile.band_selection_type }}

{% else %}
    Skip    wireless_rf_profile.band_selection_type is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//ap_band_settings{% if wireless_rf_profile.ap_band_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    ${evaluated}=    Evaluate    {{ wireless_rf_profile.ap_band_settings }}
    ${validated}=    Validate Subset     ${wireless_rf_profile}[apBandSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_rf_profile.ap_band_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//two_four_ghz_settings{% if wireless_rf_profile.two_four_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    ${evaluated}=    Evaluate    {{ wireless_rf_profile.two_four_ghz_settings }}
    ${validated}=    Validate Subset     ${wireless_rf_profile}[twoFourGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_rf_profile.two_four_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//five_ghz_settings{% if wireless_rf_profile.five_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    ${evaluated}=    Evaluate    {{ wireless_rf_profile.five_ghz_settings }}
    ${validated}=    Validate Subset     ${wireless_rf_profile}[fiveGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_rf_profile.five_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//six_ghz_settings{% if wireless_rf_profile.six_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    ${evaluated}=    Evaluate    {{ wireless_rf_profile.six_ghz_settings }}
    ${validated}=    Validate Subset     ${wireless_rf_profile}[sixGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_rf_profile.six_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//transmission{% if wireless_rf_profile.transmission is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    ${evaluated}=    Evaluate    {{ wireless_rf_profile.transmission }}
    ${validated}=    Validate Subset     ${wireless_rf_profile}[transmission]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_rf_profile.transmission is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_rf_profiles/{{ wireless_rf_profile.name }}//per_ssid_settings{% if wireless_rf_profile.per_ssid_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_rf_profile.name }}']   wireless_rf_profile
    ${evaluated}=    Evaluate    {{ wireless_rf_profile.per_ssid_settings }}
    ${validated}=    Validate Subset     ${wireless_rf_profile}[perSsidSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_rf_profile.per_ssid_settings is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
