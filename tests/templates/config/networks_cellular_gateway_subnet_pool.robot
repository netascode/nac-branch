
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set cellular_gateway_subnet_pool = network.cellular_gateway.subnet_pool | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_subnet_pool/deployment_mode{% if cellular_gateway_subnet_pool.deployment_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/subnetPool   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_subnet_pool
    Should Be Equal As Strings   ${cellular_gateway_subnet_pool}[deploymentMode]   {{ cellular_gateway_subnet_pool.deployment_mode }}

{% else %}
    Skip    cellular_gateway_subnet_pool.deployment_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_subnet_pool/cidr{% if cellular_gateway_subnet_pool.cidr is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/subnetPool   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_subnet_pool
    Should Be Equal As Strings   ${cellular_gateway_subnet_pool}[cidr]   {{ cellular_gateway_subnet_pool.cidr }}

{% else %}
    Skip    cellular_gateway_subnet_pool.cidr is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_subnet_pool/mask{% if cellular_gateway_subnet_pool.mask is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/subnetPool   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_subnet_pool
    Should Be Equal As Strings   ${cellular_gateway_subnet_pool}[mask]   {{ cellular_gateway_subnet_pool.mask }}

{% else %}
    Skip    cellular_gateway_subnet_pool.mask is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/cellular_gateway_subnet_pool/subnets{% if cellular_gateway_subnet_pool.subnets is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/cellularGateway/subnetPool   ['{{ organization.name }}', '{{ network.name }}']   cellular_gateway_subnet_pool
    ${evaluated}=    Evaluate    {{ cellular_gateway_subnet_pool.subnets }}
    ${validated}=    Validate Subset     ${cellular_gateway_subnet_pool}[subnets]    ${evaluated}     ['serial', 'name', 'appliance_ip', 'subnet']
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_subnet_pool.subnets is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
