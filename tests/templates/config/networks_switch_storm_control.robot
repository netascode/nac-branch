
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_storm_control = network.switch.storm_control | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_storm_control/broadcast_threshold{% if switch_storm_control.broadcast_threshold is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stormControl   ['{{ organization.name }}', '{{ network.name }}']   switch_storm_control
    Should Be Equal As Strings   ${switch_storm_control}[broadcastThreshold]   {{ switch_storm_control.broadcast_threshold }}

{% else %}
    Skip    switch_storm_control.broadcast_threshold is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_storm_control/multicast_threshold{% if switch_storm_control.multicast_threshold is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stormControl   ['{{ organization.name }}', '{{ network.name }}']   switch_storm_control
    Should Be Equal As Strings   ${switch_storm_control}[multicastThreshold]   {{ switch_storm_control.multicast_threshold }}

{% else %}
    Skip    switch_storm_control.multicast_threshold is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_storm_control/unknown_unicast_threshold{% if switch_storm_control.unknown_unicast_threshold is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stormControl   ['{{ organization.name }}', '{{ network.name }}']   switch_storm_control
    Should Be Equal As Strings   ${switch_storm_control}[unknownUnicastThreshold]   {{ switch_storm_control.unknown_unicast_threshold }}

{% else %}
    Skip    switch_storm_control.unknown_unicast_threshold is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_storm_control/treat_these_traffic_types_as_one_threshold{% if switch_storm_control.treat_these_traffic_types_as_one_threshold is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stormControl   ['{{ organization.name }}', '{{ network.name }}']   switch_storm_control
    ${evaluated}=    Evaluate    {{ switch_storm_control.treat_these_traffic_types_as_one_threshold }}
    ${validated}=    Validate Subset     ${switch_storm_control}[treatTheseTrafficTypesAsOneThreshold]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_storm_control.treat_these_traffic_types_as_one_threshold is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
