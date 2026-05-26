
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}
{% for switch_routing_interface in device.switch_routing_interfaces | default([], true) %}

# Note: interfaceId is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//name{% if switch_routing_interface.name is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[name]   {{ switch_routing_interface.name }}

{% else %}
    Skip    switch_routing_interface.name is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//subnet{% if switch_routing_interface.subnet is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[subnet]   {{ switch_routing_interface.subnet }}

{% else %}
    Skip    switch_routing_interface.subnet is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//interface_ip{% if switch_routing_interface.interface_ip is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[interfaceIp]   {{ switch_routing_interface.interface_ip }}

{% else %}
    Skip    switch_routing_interface.interface_ip is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//multicast_routing{% if switch_routing_interface.multicast_routing is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[multicastRouting]   {{ switch_routing_interface.multicast_routing }}

{% else %}
    Skip    switch_routing_interface.multicast_routing is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//vlan_id{% if switch_routing_interface.vlan_id is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[vlanId]   {{ switch_routing_interface.vlan_id }}

{% else %}
    Skip    switch_routing_interface.vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//ospf_settings{% if switch_routing_interface.ospf_settings is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    ${evaluated}=    Evaluate    {{ switch_routing_interface.ospf_settings }}
    ${validated}=    Validate Subset     ${switch_routing_interface}[ospfSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_interface.ospf_settings is not defined
{% endif %}
# TODO Check ospfV3:
#      if switch_routing_interface.ospf_settings.area is one of the areas in switch.routing_ospf.v3.areas,
#      check that [ospfV3] matches ospf_settings.
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//ipv6{% if switch_routing_interface.ipv6 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    ${evaluated}=    Evaluate    {{ switch_routing_interface.ipv6 }}
    ${validated}=    Validate Subset     ${switch_routing_interface}[ipv6]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_interface.ipv6 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//static_v4_dns1{% if switch_routing_interface.static_v4_dns1 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[staticV4Dns1]   {{ switch_routing_interface.static_v4_dns1 }}

{% else %}
    Skip    switch_routing_interface.static_v4_dns1 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//static_v4_dns2{% if switch_routing_interface.static_v4_dns2 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[staticV4Dns2]   {{ switch_routing_interface.static_v4_dns2 }}

{% else %}
    Skip    switch_routing_interface.static_v4_dns2 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//uplink_v4{% if switch_routing_interface.uplink_v4 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[uplinkV4]   {{ switch_routing_interface.uplink_v4 }}

{% else %}
    Skip    switch_routing_interface.uplink_v4 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//uplink_v6{% if switch_routing_interface.uplink_v6 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[uplinkV6]   {{ switch_routing_interface.uplink_v6 }}

{% else %}
    Skip    switch_routing_interface.uplink_v6 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_routing_interfaces/{{ switch_routing_interface.name }}//default_gateway{% if switch_routing_interface.default_gateway is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ device.name }}', '{{ switch_routing_interface.name }}']   switch_routing_interface
    Should Be Equal As Strings   ${switch_routing_interface}[defaultGateway]   {{ switch_routing_interface.default_gateway }}

{% else %}
    Skip    switch_routing_interface.default_gateway is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
