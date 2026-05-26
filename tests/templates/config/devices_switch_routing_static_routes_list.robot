
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}
{% for switch_routing_static_route in device.switch.routing_static_routes | default([], true) %}
# Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//static_route_id{% if switch_routing_static_route.static_route_id is defined %}
#     [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
#     Should Be Equal As Strings   ${switch_routing_static_route}[staticRouteId]   {{ switch_routing_static_route.static_route_id }}

# {% else %}
#     Skip    switch_routing_static_route.static_route_id is not defined
# {% endif %}

Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//name{% if switch_routing_static_route.name is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
    Should Be Equal As Strings   ${switch_routing_static_route}[name]   {{ switch_routing_static_route.name }}

{% else %}
    Skip    switch_routing_static_route.name is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//subnet{% if switch_routing_static_route.subnet is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
    Should Be Equal As Strings   ${switch_routing_static_route}[subnet]   {{ switch_routing_static_route.subnet }}

{% else %}
    Skip    switch_routing_static_route.subnet is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//next_hop_ip{% if switch_routing_static_route.next_hop_ip is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
    Should Be Equal As Strings   ${switch_routing_static_route}[nextHopIp]   {{ switch_routing_static_route.next_hop_ip }}

{% else %}
    Skip    switch_routing_static_route.next_hop_ip is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//management_next_hop{% if switch_routing_static_route.management_next_hop is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
    Should Be Equal As Strings   ${switch_routing_static_route}[managementNextHop]   {{ switch_routing_static_route.management_next_hop }}

{% else %}
    Skip    switch_routing_static_route.management_next_hop is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//advertise_via_ospf{% if switch_routing_static_route.advertise_via_ospf is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
    Should Be Equal As Strings   ${switch_routing_static_route}[advertiseViaOspfEnabled]   {{ switch_routing_static_route.advertise_via_ospf }}

{% else %}
    Skip    switch_routing_static_route.advertise_via_ospf is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch.routing_static_routes/{{ switch_routing_static_route.name }}//prefer_over_ospf_routes{% if switch_routing_static_route.prefer_over_ospf_routes is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_static_route.name }}']   switch_routing_static_route
    Should Be Equal As Strings   ${switch_routing_static_route}[preferOverOspfRoutesEnabled]   {{ switch_routing_static_route.prefer_over_ospf_routes }}

{% else %}
    Skip    switch_routing_static_route.prefer_over_ospf_routes is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
