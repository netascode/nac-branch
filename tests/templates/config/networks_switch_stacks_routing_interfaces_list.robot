
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for switch_stack in network.switch_stacks | default([], true) %}
{% for routing_interface in switch_stack.routing_interfaces | default([], true) %}

# Note: interfaceId is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//name{% if routing_interface.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[name]   {{ routing_interface.name }}

{% else %}
    Skip    routing_interface.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//subnet{% if routing_interface.subnet is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[subnet]   {{ routing_interface.subnet }}

{% else %}
    Skip    routing_interface.subnet is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//interface_ip{% if routing_interface.interface_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[interfaceIp]   {{ routing_interface.interface_ip }}

{% else %}
    Skip    routing_interface.interface_ip is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//multicast_routing{% if routing_interface.multicast_routing is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[multicastRouting]   {{ routing_interface.multicast_routing }}

{% else %}
    Skip    routing_interface.multicast_routing is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//vlan_id{% if routing_interface.vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[vlanId]   {{ routing_interface.vlan_id }}

{% else %}
    Skip    routing_interface.vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//ospf_settings{% if routing_interface.ospf_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    ${evaluated}=    Evaluate    {{ routing_interface.ospf_settings }}
    ${validated}=    Validate Subset     ${routing_interface}[ospfSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    routing_interface.ospf_settings is not defined
{% endif %}
# TODO Check ospfV3:
#      if routing_interface.ospf_settings.area is one of the areas in switch.routing_ospf.v3.areas,
#      check that [ospfV3] matches ospf_settings.
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//ipv6{% if routing_interface.ipv6 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    ${evaluated}=    Evaluate    {{ routing_interface.ipv6 }}
    ${validated}=    Validate Subset     ${routing_interface}[ipv6]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    routing_interface.ipv6 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//static_v4_dns1{% if routing_interface.static_v4_dns1 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[staticV4Dns1]   {{ routing_interface.static_v4_dns1 }}

{% else %}
    Skip    routing_interface.static_v4_dns1 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//static_v4_dns2{% if routing_interface.static_v4_dns2 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[staticV4Dns2]   {{ routing_interface.static_v4_dns2 }}

{% else %}
    Skip    routing_interface.static_v4_dns2 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//uplink_v4{% if routing_interface.uplink_v4 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[uplinkV4]   {{ routing_interface.uplink_v4 }}

{% else %}
    Skip    routing_interface.uplink_v4 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//uplink_v6{% if routing_interface.uplink_v6 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[uplinkV6]   {{ routing_interface.uplink_v6 }}

{% else %}
    Skip    routing_interface.uplink_v6 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}//default_gateway{% if routing_interface.default_gateway is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   routing_interface
    Should Be Equal As Strings   ${routing_interface}[defaultGateway]   {{ routing_interface.default_gateway }}

{% else %}
    Skip    routing_interface.default_gateway is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
