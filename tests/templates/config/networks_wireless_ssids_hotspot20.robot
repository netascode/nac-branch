
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set hotspot20 = wireless_ssid.hotspot20 | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/enabled{% if hotspot20.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    Should Be Equal As Strings   ${hotspot20}[enabled]   {{ hotspot20.enabled }}

{% else %}
    Skip    hotspot20.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/operator{% if hotspot20.operator is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    Should Be Equal As Strings   ${hotspot20}[operator][name]   {{ hotspot20.operator }}

{% else %}
    Skip    hotspot20.operator is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/venue{% if hotspot20.venue is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    ${evaluated}=    Evaluate    {{ hotspot20.venue }}
    ${validated}=    Validate Subset     ${hotspot20}[venue]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    hotspot20.venue is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/network_access_type{% if hotspot20.network_access_type is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    Should Be Equal As Strings   ${hotspot20}[networkAccessType]   {{ hotspot20.network_access_type }}

{% else %}
    Skip    hotspot20.network_access_type is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/domains{% if hotspot20.domains is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    ${evaluated}=    Evaluate    {{ hotspot20.domains }}
    ${validated}=    Validate Subset     ${hotspot20}[domains]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    hotspot20.domains is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/roam_consort_ois{% if hotspot20.roam_consort_ois is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    ${evaluated}=    Evaluate    {{ hotspot20.roam_consort_ois }}
    ${validated}=    Validate Subset     ${hotspot20}[roamConsortOis]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    hotspot20.roam_consort_ois is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/mcc_mncs{% if hotspot20.mcc_mncs is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    ${evaluated}=    Evaluate    {{ hotspot20.mcc_mncs }}
    ${validated}=    Validate Subset     ${hotspot20}[mccMncs]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    hotspot20.mcc_mncs is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/hotspot20/nai_realms{% if hotspot20.nai_realms is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/hotspot20   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   hotspot20
    ${evaluated}=    Evaluate    {{ hotspot20.nai_realms }}
    ${validated}=    Validate Subset     ${hotspot20}[naiRealms]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    hotspot20.nai_realms is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
