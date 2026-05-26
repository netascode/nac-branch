
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for switch_stack in network.switch_stacks | default([], true) %}
{% for routing_static_route in switch_stack.routing_static_routes | default([], true) %}

# Note: staticRouteId is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_static_routes/{{ routing_static_route.name }}//name{% if routing_static_route.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_static_route.name }}']   routing_static_route
    Should Be Equal As Strings   ${routing_static_route}[name]   {{ routing_static_route.name }}

{% else %}
    Skip    routing_static_route.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_static_routes/{{ routing_static_route.name }}//subnet{% if routing_static_route.subnet is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_static_route.name }}']   routing_static_route
    Should Be Equal As Strings   ${routing_static_route}[subnet]   {{ routing_static_route.subnet }}

{% else %}
    Skip    routing_static_route.subnet is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_static_routes/{{ routing_static_route.name }}//next_hop_ip{% if routing_static_route.next_hop_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_static_route.name }}']   routing_static_route
    Should Be Equal As Strings   ${routing_static_route}[nextHopIp]   {{ routing_static_route.next_hop_ip }}

{% else %}
    Skip    routing_static_route.next_hop_ip is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_static_routes/{{ routing_static_route.name }}//management_next_hop{% if routing_static_route.management_next_hop is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_static_route.name }}']   routing_static_route
    Should Be Equal As Strings   ${routing_static_route}[managementNextHop]   {{ routing_static_route.management_next_hop }}

{% else %}
    Skip    routing_static_route.management_next_hop is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_static_routes/{{ routing_static_route.name }}//advertise_via_ospf{% if routing_static_route.advertise_via_ospf is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_static_route.name }}']   routing_static_route
    Should Be Equal As Strings   ${routing_static_route}[advertiseViaOspfEnabled]   {{ routing_static_route.advertise_via_ospf }}

{% else %}
    Skip    routing_static_route.advertise_via_ospf is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_static_routes/{{ routing_static_route.name }}//prefer_over_ospf_routes{% if routing_static_route.prefer_over_ospf_routes is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_static_route.name }}']   routing_static_route
    Should Be Equal As Strings   ${routing_static_route}[preferOverOspfRoutesEnabled]   {{ routing_static_route.prefer_over_ospf_routes }}

{% else %}
    Skip    routing_static_route.prefer_over_ospf_routes is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
