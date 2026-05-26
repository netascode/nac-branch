
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_dhcp_server_policy_arp_inspection_trusted_servers = network.switch.dhcp_server_policy.arp_inspection_trusted_servers | default(none) %}
Verify Array {{ organization.name }}/networks/{{ network.name }}/switch.dhcp_server_policy.arp_inspection_trusted_servers switch_dhcp_server_policy_arp_inspection_trusted_servers{% if switch_dhcp_server_policy_arp_inspection_trusted_servers is not none %}
    # TODO Handle paging if the data can have >1000 entries - otherwise, only the first 1000 will be returned.
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dhcpServerPolicy/arpInspection/trustedServers   ['{{ organization.name }}', '{{ network.name }}']   switch_dhcp_server_policy_arp_inspection_trusted_servers
    ${evaluated}=    Evaluate    {{ switch_dhcp_server_policy_arp_inspection_trusted_servers }}
    ${evaluated}=    Unflatten Dicts In Property    ${evaluated}    prop=ipv4_address    add_key=address
    ${evaluated}=    Rename Property    ${evaluated}    ipv4_address    ipv4
    ${validated}=    Validate Subset     ${switch_dhcp_server_policy_arp_inspection_trusted_servers}    ${evaluated}     ['mac', 'vlan', 'ipv4']
    Should Be True   ${validated}
{% else %}
    Skip   switch_dhcp_server_policy_arp_inspection_trusted_servers is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
