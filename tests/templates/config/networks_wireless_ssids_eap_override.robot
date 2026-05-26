
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set eap_override = wireless_ssid.eap_override | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/eap_override/timeout{% if eap_override.timeout is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/eapOverride   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   eap_override
    Should Be Equal As Strings   ${eap_override}[timeout]   {{ eap_override.timeout }}

{% else %}
    Skip    eap_override.timeout is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/eap_override/max_retries{% if eap_override.max_retries is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/eapOverride   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   eap_override
    Should Be Equal As Strings   ${eap_override}[maxRetries]   {{ eap_override.max_retries }}

{% else %}
    Skip    eap_override.max_retries is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/eap_override/identity{% if eap_override.identity is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/eapOverride   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   eap_override
    ${evaluated}=    Evaluate    {{ eap_override.identity }}
    ${validated}=    Validate Subset     ${eap_override}[identity]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    eap_override.identity is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/eap_override/eapol_key{% if eap_override.eapol_key is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/eapOverride   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   eap_override
    ${evaluated}=    Evaluate    {{ eap_override.eapol_key }}
    ${validated}=    Validate Subset     ${eap_override}[eapolKey]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    eap_override.eapol_key is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
