
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set unavailability_schedules = wireless_ssid.unavailability_schedules | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/unavailability_schedules/enabled{% if unavailability_schedules.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/schedules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   schedules
    Should Be Equal As Strings   ${schedules}[enabled]   {{ unavailability_schedules.enabled }}

{% else %}
    Skip    unavailability_schedules.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/unavailability_schedules/ranges{% if unavailability_schedules.ranges is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/schedules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   schedules
    ${evaluated}=    Evaluate    {{ unavailability_schedules.ranges }}
    ${validated}=    Validate Subset     ${schedules}[ranges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    unavailability_schedules.ranges is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/unavailability_schedules/ranges_in_seconds{% if unavailability_schedules.ranges_in_seconds is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/schedules   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   schedules
    ${evaluated}=    Evaluate    {{ unavailability_schedules.ranges_in_seconds }}
    ${validated}=    Validate Subset     ${schedules}[rangesInSeconds]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    unavailability_schedules.ranges_in_seconds is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
