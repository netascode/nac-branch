
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for switch_routing_multicast_rendezvous_point in network.switch.routing_multicast_rendezvous_points | default([], true) %}
# Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/switch_routing_multicast_rendezvous_points/{{ switch_routing_multicast_rendezvous_point.interface_ip }}//rendezvous_point_id{% if switch_routing_multicast_rendezvous_point.rendezvous_point_id is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast/rendezvousPoints/{rendezvousPointId}   ['{{organization.name}}', '{{ network.name }}', '{{ switch_routing_multicast_rendezvous_point.interface_ip }}']   switch_routing_multicast_rendezvous_point
#     Should Be Equal As Strings   ${switch_routing_multicast_rendezvous_point}[rendezvousPointId]   {{ switch_routing_multicast_rendezvous_point.rendezvous_point_id }}

# {% else %}
#     Skip    switch_routing_multicast_rendezvous_point.rendezvous_point_id is not defined
# {% endif %}
# Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/switch_routing_multicast_rendezvous_points/{{ switch_routing_multicast_rendezvous_point.interface_ip }}//serial{% if switch_routing_multicast_rendezvous_point.serial is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast/rendezvousPoints/{rendezvousPointId}   ['{{organization.name}}', '{{ network.name }}', '{{ switch_routing_multicast_rendezvous_point.interface_ip }}']   switch_routing_multicast_rendezvous_point
#     Should Be Equal As Strings   ${switch_routing_multicast_rendezvous_point}[serial]   {{ switch_routing_multicast_rendezvous_point.serial }}

# {% else %}
#     Skip    switch_routing_multicast_rendezvous_point.serial is not defined
# {% endif %}
# Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/switch_routing_multicast_rendezvous_points/{{ switch_routing_multicast_rendezvous_point.interface_ip }}//interface_name{% if switch_routing_multicast_rendezvous_point.interface_name is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast/rendezvousPoints/{rendezvousPointId}   ['{{organization.name}}', '{{ network.name }}', '{{ switch_routing_multicast_rendezvous_point.interface_ip }}']   switch_routing_multicast_rendezvous_point
#     Should Be Equal As Strings   ${switch_routing_multicast_rendezvous_point}[interfaceName]   {{ switch_routing_multicast_rendezvous_point.interface_name }}

# {% else %}
#     Skip    switch_routing_multicast_rendezvous_point.interface_name is not defined
# {% endif %}

Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/switch_routing_multicast_rendezvous_points/{{ switch_routing_multicast_rendezvous_point.interface_ip }}//interface_ip{% if switch_routing_multicast_rendezvous_point.interface_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast/rendezvousPoints/{rendezvousPointId}   ['{{organization.name}}', '{{ network.name }}', '{{ switch_routing_multicast_rendezvous_point.interface_ip }}']   switch_routing_multicast_rendezvous_point
    Should Be Equal As Strings   ${switch_routing_multicast_rendezvous_point}[interfaceIp]   {{ switch_routing_multicast_rendezvous_point.interface_ip }}

{% else %}
    Skip    switch_routing_multicast_rendezvous_point.interface_ip is not defined
{% endif %}
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/switch_routing_multicast_rendezvous_points/{{ switch_routing_multicast_rendezvous_point.interface_ip }}//multicast_group{% if switch_routing_multicast_rendezvous_point.multicast_group is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast/rendezvousPoints/{rendezvousPointId}   ['{{organization.name}}', '{{ network.name }}', '{{ switch_routing_multicast_rendezvous_point.interface_ip }}']   switch_routing_multicast_rendezvous_point
    Should Be Equal As Strings   ${switch_routing_multicast_rendezvous_point}[multicastGroup]   {{ switch_routing_multicast_rendezvous_point.multicast_group }}

{% else %}
    Skip    switch_routing_multicast_rendezvous_point.multicast_group is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
