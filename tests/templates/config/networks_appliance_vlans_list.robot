
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for appliance_vlan in network.appliance.vlans | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//id{% if appliance_vlan.vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[id]   {{ appliance_vlan.vlan_id }}

{% else %}
    Skip    appliance_vlan.vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//name{% if appliance_vlan.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[name]   {{ appliance_vlan.name }}

{% else %}
    Skip    appliance_vlan.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//subnet{% if appliance_vlan.subnet is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[subnet]   {{ appliance_vlan.subnet }}

{% else %}
    Skip    appliance_vlan.subnet is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//appliance_ip{% if appliance_vlan.appliance_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[applianceIp]   {{ appliance_vlan.appliance_ip }}

{% else %}
    Skip    appliance_vlan.appliance_ip is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//group_policy_name{% if appliance_vlan.group_policy_name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    "{{ appliance_vlan.group_policy_name }}"
    ${evaluated}=    Map Names To Ids    ${evaluated}    /networks/{networkId}/groupPolicies/{groupPolicyId}    ['{{ organization.name }}', '{{ network.name }}']
    Should Be Equal As Strings   ${appliance_vlan}[groupPolicyId]   ${evaluated}

{% else %}
    Skip    appliance_vlan.group_policy_name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_relay_server_ips{% if appliance_vlan.dhcp_relay_server_ips is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    {{ appliance_vlan.dhcp_relay_server_ips }}
    ${validated}=    Validate Subset     ${appliance_vlan}[dhcpRelayServerIps]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vlan.dhcp_relay_server_ips is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_handling{% if appliance_vlan.dhcp_handling is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[dhcpHandling]   {{ appliance_vlan.dhcp_handling }}

{% else %}
    Skip    appliance_vlan.dhcp_handling is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_lease_time{% if appliance_vlan.dhcp_lease_time is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[dhcpLeaseTime]   {{ appliance_vlan.dhcp_lease_time }}

{% else %}
    Skip    appliance_vlan.dhcp_lease_time is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_boot_options_enabled{% if appliance_vlan.dhcp_boot_options_enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[dhcpBootOptionsEnabled]   {{ appliance_vlan.dhcp_boot_options_enabled }}

{% else %}
    Skip    appliance_vlan.dhcp_boot_options_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_boot_next_server{% if appliance_vlan.dhcp_boot_next_server is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[dhcpBootNextServer]   {{ appliance_vlan.dhcp_boot_next_server }}

{% else %}
    Skip    appliance_vlan.dhcp_boot_next_server is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_boot_filename{% if appliance_vlan.dhcp_boot_filename is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[dhcpBootFilename]   {{ appliance_vlan.dhcp_boot_filename }}

{% else %}
    Skip    appliance_vlan.dhcp_boot_filename is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//fixed_ip_assignments{% if appliance_vlan.fixed_ip_assignments is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    {{ appliance_vlan.fixed_ip_assignments }}
    ${evaluated}=    Map Fixed IP Assignments To API    ${evaluated}
    ${validated}=    Validate Subset     ${appliance_vlan}[fixedIpAssignments]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vlan.fixed_ip_assignments is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//reserved_ip_ranges{% if appliance_vlan.reserved_ip_ranges is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    {{ appliance_vlan.reserved_ip_ranges }}
    ${validated}=    Validate Subset     ${appliance_vlan}[reservedIpRanges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vlan.reserved_ip_ranges is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dns_nameservers{% if appliance_vlan.dns_nameservers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[dnsNameservers]   {{ appliance_vlan.dns_nameservers | normalize_special_string }}

{% else %}
    Skip    appliance_vlan.dns_nameservers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//dhcp_options{% if appliance_vlan.dhcp_options is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    {{ appliance_vlan.dhcp_options }}
    ${validated}=    Validate Subset     ${appliance_vlan}[dhcpOptions]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vlan.dhcp_options is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//vpn_nat_subnet{% if appliance_vlan.vpn_nat_subnet is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    Should Be Equal As Strings   ${appliance_vlan}[vpnNatSubnet]   {{ appliance_vlan.vpn_nat_subnet }}

{% else %}
    Skip    appliance_vlan.vpn_nat_subnet is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//mandatory_dhcp{% if appliance_vlan.mandatory_dhcp is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    {{ appliance_vlan.mandatory_dhcp }}
    ${validated}=    Validate Subset     ${appliance_vlan}[mandatoryDhcp][enabled]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vlan.mandatory_dhcp is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans/{{ appliance_vlan.name }}//ipv6{% if appliance_vlan.ipv6 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/{vlanId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_vlan.name }}']   appliance_vlan
    ${evaluated}=    Evaluate    {{ appliance_vlan.ipv6 }}
    ${validated}=    Validate Subset     ${appliance_vlan}[ipv6]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_vlan.ipv6 is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
