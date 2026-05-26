
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}
{% for identity_psk in wireless_ssid.identity_psks | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//name{% if identity_psk.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    Should Be Equal As Strings   ${identity_psk}[name]   {{ identity_psk.name }}

{% else %}
    Skip    identity_psk.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//id{% if identity_psk.id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    Should Be Equal As Strings   ${identity_psk}[id]   {{ identity_psk.id }}

{% else %}
    Skip    identity_psk.id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//group_policy_name{% if identity_psk.group_policy_name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    ${evaluated}=    Evaluate    "{{ identity_psk.group_policy_name }}"
    ${evaluated}=    Map Names To Ids    ${evaluated}    /networks/{networkId}/groupPolicies/{groupPolicyId}    ['{{ organization.name }}', '{{ network.name }}']
    Should Be Equal As Strings   ${identity_psk}[groupPolicyId]   ${evaluated}

{% else %}
    Skip    identity_psk.group_policy_name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//passphrase{% if identity_psk.passphrase is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    Should Be Equal As Strings   ${identity_psk}[passphrase]   {{ identity_psk.passphrase }}

{% else %}
    Skip    identity_psk.passphrase is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//wifi_personal_network_id{% if identity_psk.wifi_personal_network_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    Should Be Equal As Strings   ${identity_psk}[wifiPersonalNetworkId]   {{ identity_psk.wifi_personal_network_id }}

{% else %}
    Skip    identity_psk.wifi_personal_network_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//email{% if identity_psk.email is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    Should Be Equal As Strings   ${identity_psk}[email]   {{ identity_psk.email }}

{% else %}
    Skip    identity_psk.email is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/identity_psks/{{ identity_psk.name }}//expires_at{% if identity_psk.expires_at is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/identityPsks/{identityPskId}   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}', '{{ identity_psk.name }}']   identity_psk
    Should Be Equal As Strings   ${identity_psk}[expiresAt]   {{ identity_psk.expires_at }}

{% else %}
    Skip    identity_psk.expires_at is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
