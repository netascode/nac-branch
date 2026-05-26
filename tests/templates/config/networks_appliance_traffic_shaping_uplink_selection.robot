
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_traffic_shaping_uplink_selection = network.appliance.traffic_shaping.uplink_selection | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping.uplink_selection/active_active_auto_vpn{% if appliance_traffic_shaping_uplink_selection.active_active_auto_vpn is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/uplinkSelection   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_uplink_selection
    Should Be Equal As Strings   ${appliance_traffic_shaping_uplink_selection}[activeActiveAutoVpnEnabled]   {{ appliance_traffic_shaping_uplink_selection.active_active_auto_vpn }}

{% else %}
    Skip    appliance.traffic_shaping.uplink_selection.active_active_auto_vpn is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping.uplink_selection/default_uplink{% if appliance_traffic_shaping_uplink_selection.default_uplink is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/uplinkSelection   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_uplink_selection
    Should Be Equal As Strings   ${appliance_traffic_shaping_uplink_selection}[defaultUplink]   {{ appliance_traffic_shaping_uplink_selection.default_uplink }}

{% else %}
    Skip    appliance.traffic_shaping.uplink_selection.default_uplink is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_traffic_shaping_uplink_selection/load_balancing{% if appliance_traffic_shaping_uplink_selection.load_balancing is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/uplinkSelection   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_uplink_selection
    Should Be Equal As Strings   ${appliance_traffic_shaping_uplink_selection}[loadBalancingEnabled]   {{ appliance_traffic_shaping_uplink_selection.load_balancing }}

{% else %}
    Skip    appliance.traffic_shaping.uplink_selection.load_balancing is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping.uplink_selection/failover_and_failback_immediate{% if appliance_traffic_shaping_uplink_selection.failover_and_failback_immediate is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/uplinkSelection   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_uplink_selection
    Should Be Equal As Strings   ${appliance_traffic_shaping_uplink_selection}[failoverAndFailback][immediate][enabled]   {{ appliance_traffic_shaping_uplink_selection.failover_and_failback_immediate }}

{% else %}
    Skip    appliance.traffic_shaping.uplink_selection.failover_and_failback_immediate is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping.uplink_selection/wan_traffic_uplink_preferences{% if appliance_traffic_shaping_uplink_selection.wan_traffic_uplink_preferences is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/uplinkSelection   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_uplink_selection
    ${evaluated}=    Evaluate    {{ appliance_traffic_shaping_uplink_selection.wan_traffic_uplink_preferences }}
    ${validated}=    Validate Subset     ${appliance_traffic_shaping_uplink_selection}[wanTrafficUplinkPreferences]    ${evaluated}    ['traffic_filters', 'preferred_uplink']
    Should Be True   ${validated}

{% else %}
    Skip    appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.traffic_shaping.uplink_selection/vpn_traffic_uplink_preferences{% if appliance_traffic_shaping_uplink_selection.vpn_traffic_uplink_preferences is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/trafficShaping/uplinkSelection   ['{{ organization.name }}', '{{ network.name }}']   appliance_traffic_shaping_uplink_selection
    ${evaluated}=    Evaluate    {{ appliance_traffic_shaping_uplink_selection.vpn_traffic_uplink_preferences }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}    ['{{ organization.name }}', '{{ network.name }}']    path=performance_class    name_prop=custom_performance_class_name    id_prop=custom_performance_class_id
    ${validated}=    Validate Subset     ${appliance_traffic_shaping_uplink_selection}[vpnTrafficUplinkPreferences]    ${evaluated}    ['traffic_filters', 'preferred_uplink', 'fail_over_criterion', 'performance_class']
    Should Be True   ${validated}

{% else %}
    Skip    appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
