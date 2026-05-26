
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for switch_stack in network.switch_stacks | default([], true) %}
{% for routing_interface in switch_stack.routing_interfaces | default([], true) %}

{% set dhcp = routing_interface.dhcp | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/dhcp_mode{% if dhcp.dhcp_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    Should Be Equal As Strings   ${dhcp}[dhcpMode]   {{ dhcp.dhcp_mode }}

{% else %}
    Skip    dhcp.dhcp_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/dhcp_relay_server_ips{% if dhcp.dhcp_relay_server_ips is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    ${evaluated}=    Evaluate    {{ dhcp.dhcp_relay_server_ips }}
    ${validated}=    Validate Subset     ${dhcp}[dhcpRelayServerIps]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    dhcp.dhcp_relay_server_ips is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/dhcp_lease_time{% if dhcp.dhcp_lease_time is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    Should Be Equal As Strings   ${dhcp}[dhcpLeaseTime]   {{ dhcp.dhcp_lease_time }}

{% else %}
    Skip    dhcp.dhcp_lease_time is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/dns_nameservers_option{% if dhcp.dns_nameservers_option is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    Should Be Equal As Strings   ${dhcp}[dnsNameserversOption]   {{ dhcp.dns_nameservers_option }}

{% else %}
    Skip    dhcp.dns_nameservers_option is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/dns_custom_nameservers{% if dhcp.dns_custom_nameservers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    ${evaluated}=    Evaluate    {{ dhcp.dns_custom_nameservers }}
    ${validated}=    Validate Subset     ${dhcp}[dnsCustomNameservers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    dhcp.dns_custom_nameservers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/boot_options{% if dhcp.boot_options is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    Should Be Equal As Strings   ${dhcp}[bootOptionsEnabled]   {{ dhcp.boot_options }}

{% else %}
    Skip    dhcp.boot_options is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/boot_next_server{% if dhcp.boot_next_server is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    Should Be Equal As Strings   ${dhcp}[bootNextServer]   {{ dhcp.boot_next_server }}

{% else %}
    Skip    dhcp.boot_next_server is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/boot_file_name{% if dhcp.boot_file_name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    Should Be Equal As Strings   ${dhcp}[bootFileName]   {{ dhcp.boot_file_name }}

{% else %}
    Skip    dhcp.boot_file_name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/dhcp_options{% if dhcp.dhcp_options is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    ${evaluated}=    Evaluate    {{ dhcp.dhcp_options }}
    ${validated}=    Validate Subset     ${dhcp}[dhcpOptions]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    dhcp.dhcp_options is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/reserved_ip_ranges{% if dhcp.reserved_ip_ranges is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    ${evaluated}=    Evaluate    {{ dhcp.reserved_ip_ranges }}
    ${validated}=    Validate Subset     ${dhcp}[reservedIpRanges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    dhcp.reserved_ip_ranges is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}/routing_interfaces/{{ routing_interface.name }}/dhcp/fixed_ip_assignments{% if dhcp.fixed_ip_assignments is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}/routing/interfaces/{interfaceId}/dhcp   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}', '{{ routing_interface.name }}']   dhcp
    ${evaluated}=    Evaluate    {{ dhcp.fixed_ip_assignments }}
    ${validated}=    Validate Subset     ${dhcp}[fixedIpAssignments]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    dhcp.fixed_ip_assignments is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
