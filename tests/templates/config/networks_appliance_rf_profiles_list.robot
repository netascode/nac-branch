
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for appliance_rf_profile in network.appliance.rf_profiles | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_rf_profiles/{{ appliance_rf_profile.name }}//id{% if appliance_rf_profile.id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_rf_profile.name }}']   appliance_rf_profile
    Should Be Equal As Strings   ${appliance_rf_profile}[id]   {{ appliance_rf_profile.id }}

{% else %}
    Skip    appliance_rf_profile.id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_rf_profiles/{{ appliance_rf_profile.name }}//network_id{% if appliance_rf_profile.network_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_rf_profile.name }}']   appliance_rf_profile
    Should Be Equal As Strings   ${appliance_rf_profile}[networkId]   {{ appliance_rf_profile.network_id }}

{% else %}
    Skip    appliance_rf_profile.network_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_rf_profiles/{{ appliance_rf_profile.name }}//name{% if appliance_rf_profile.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_rf_profile.name }}']   appliance_rf_profile
    Should Be Equal As Strings   ${appliance_rf_profile}[name]   {{ appliance_rf_profile.name }}

{% else %}
    Skip    appliance_rf_profile.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_rf_profiles/{{ appliance_rf_profile.name }}//two_four_ghz_settings{% if appliance_rf_profile.two_four_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_rf_profile.name }}']   appliance_rf_profile
    ${evaluated}=    Evaluate    {{ appliance_rf_profile.two_four_ghz_settings }}
    ${validated}=    Validate Subset     ${appliance_rf_profile}[twoFourGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_rf_profile.two_four_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_rf_profiles/{{ appliance_rf_profile.name }}//five_ghz_settings{% if appliance_rf_profile.five_ghz_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_rf_profile.name }}']   appliance_rf_profile
    ${evaluated}=    Evaluate    {{ appliance_rf_profile.five_ghz_settings }}
    ${validated}=    Validate Subset     ${appliance_rf_profile}[fiveGhzSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_rf_profile.five_ghz_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_rf_profiles/{{ appliance_rf_profile.name }}//per_ssid_settings{% if appliance_rf_profile.per_ssid_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/rfProfiles/{rfProfileId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_rf_profile.name }}']   appliance_rf_profile
    Get Meraki Data   /networks/{networkId}/appliance/ssids   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssids
    ${evaluated}=    Evaluate    {{ appliance_rf_profile.per_ssid_settings }}
    ${validated}=    Validate Appliance Per Ssid Settings     ${appliance_rf_profile}[perSsidSettings]    ${evaluated}   ${appliance_ssids}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_rf_profile.per_ssid_settings is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
