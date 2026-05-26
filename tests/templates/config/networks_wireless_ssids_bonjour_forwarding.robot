
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set bonjour_forwarding = wireless_ssid.bonjour_forwarding | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/bonjour_forwarding/enabled{% if bonjour_forwarding.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/bonjourForwarding   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   bonjour_forwarding
    Should Be Equal As Strings   ${bonjour_forwarding}[enabled]   {{ bonjour_forwarding.enabled }}

{% else %}
    Skip    bonjour_forwarding.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/bonjour_forwarding/exception{% if bonjour_forwarding.exception is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/bonjourForwarding   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   bonjour_forwarding
    Should Be Equal As Strings   ${bonjour_forwarding}[exception][enabled]   {{ bonjour_forwarding.exception }}

{% else %}
    Skip    bonjour_forwarding.exception is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/bonjour_forwarding/rules{% if bonjour_forwarding.rules is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/bonjourForwarding   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   bonjour_forwarding
    ${evaluated}=    Evaluate    {{ bonjour_forwarding.rules }}
    ${validated}=    Validate Subset     ${bonjour_forwarding}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    bonjour_forwarding.rules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
