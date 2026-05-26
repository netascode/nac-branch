
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set cellular_gateway_dhcp = network.cellular_gateway.dhcp | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_dhcp/dhcp_lease_time{% if cellular_gateway_dhcp.dhcp_lease_time is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/dhcp   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_dhcp
    Should Be Equal As Strings   ${cellular_gateway_dhcp}[dhcpLeaseTime]   {{ cellular_gateway_dhcp.dhcp_lease_time }}

{% else %}
    Skip    cellular_gateway_dhcp.dhcp_lease_time is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_dhcp/dns_nameservers{% if cellular_gateway_dhcp.dns_nameservers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/dhcp   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_dhcp
    Should Be Equal As Strings   ${cellular_gateway_dhcp}[dnsNameservers]   {{ cellular_gateway_dhcp.dns_nameservers }}

{% else %}
    Skip    cellular_gateway_dhcp.dns_nameservers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_dhcp/dns_custom_nameservers{% if cellular_gateway_dhcp.dns_custom_nameservers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/dhcp   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_dhcp
    ${evaluated}=    Evaluate    {{ cellular_gateway_dhcp.dns_custom_nameservers }}
    ${validated}=    Validate Subset     ${cellular_gateway_dhcp}[dnsCustomNameservers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_dhcp.dns_custom_nameservers is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
