
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_dhcp_server_policy = network.switch.dhcp_server_policy | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_dhcp_server_policy/alerts_email{% if switch_dhcp_server_policy.alerts_email is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dhcpServerPolicy   ['{{ organization.name }}', '{{ network.name }}']   switch_dhcp_server_policy
    Should Be Equal As Strings   ${switch_dhcp_server_policy}[alerts][email][enabled]    {{ switch_dhcp_server_policy.alerts_email }}

{% else %}
    Skip    switch_dhcp_server_policy.alerts_email is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_dhcp_server_policy/default_policy{% if switch_dhcp_server_policy.default_policy is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dhcpServerPolicy   ['{{ organization.name }}', '{{ network.name }}']   switch_dhcp_server_policy
    Should Be Equal As Strings   ${switch_dhcp_server_policy}[defaultPolicy]   {{ switch_dhcp_server_policy.default_policy }}

{% else %}
    Skip    switch_dhcp_server_policy.default_policy is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_dhcp_server_policy/blocked_servers{% if switch_dhcp_server_policy.blocked_servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dhcpServerPolicy   ['{{ organization.name }}', '{{ network.name }}']   switch_dhcp_server_policy
    ${evaluated}=    Evaluate    {{ switch_dhcp_server_policy.blocked_servers }}
    ${validated}=    Validate Subset     ${switch_dhcp_server_policy}[blockedServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_dhcp_server_policy.blocked_servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_dhcp_server_policy/allowed_servers{% if switch_dhcp_server_policy.allowed_servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dhcpServerPolicy   ['{{ organization.name }}', '{{ network.name }}']   switch_dhcp_server_policy
    ${evaluated}=    Evaluate    {{ switch_dhcp_server_policy.allowed_servers }}
    ${validated}=    Validate Subset     ${switch_dhcp_server_policy}[allowedServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_dhcp_server_policy.allowed_servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_dhcp_server_policy/arp_inspection{% if switch_dhcp_server_policy.arp_inspection is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dhcpServerPolicy   ['{{ organization.name }}', '{{ network.name }}']   switch_dhcp_server_policy
    Should Be Equal As Strings   ${switch_dhcp_server_policy}[arpInspection][enabled]   {{ switch_dhcp_server_policy.arp_inspection }}

{% else %}
    Skip    switch_dhcp_server_policy.arp_inspection is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
