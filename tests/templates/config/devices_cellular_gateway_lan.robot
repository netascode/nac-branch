
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.cellular_gateway is defined %}
{% set cellular_gateway_lan = device.cellular_gateway.lan | default({}, true) %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_gateway_lan/device_name{% if cellular_gateway_lan.device_name is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellularGateway/lan   ['{{ organization.name }}', '{{ device.name }}']   cellular_gateway_lan
    Should Be Equal As Strings   ${cellular_gateway_lan}[deviceName]   {{ cellular_gateway_lan.device_name }}

{% else %}
    Skip    cellular_gateway_lan.device_name is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_gateway_lan/device_lan_ip{% if cellular_gateway_lan.device_lan_ip is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellularGateway/lan   ['{{ organization.name }}', '{{ device.name }}']   cellular_gateway_lan
    Should Be Equal As Strings   ${cellular_gateway_lan}[deviceLanIp]   {{ cellular_gateway_lan.device_lan_ip }}

{% else %}
    Skip    cellular_gateway_lan.device_lan_ip is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_gateway_lan/device_subnet{% if cellular_gateway_lan.device_subnet is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellularGateway/lan   ['{{ organization.name }}', '{{ device.name }}']   cellular_gateway_lan
    Should Be Equal As Strings   ${cellular_gateway_lan}[deviceSubnet]   {{ cellular_gateway_lan.device_subnet }}

{% else %}
    Skip    cellular_gateway_lan.device_subnet is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_gateway_lan/fixed_ip_assignments{% if cellular_gateway_lan.fixed_ip_assignments is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellularGateway/lan   ['{{ organization.name }}', '{{ device.name }}']   cellular_gateway_lan
    ${evaluated}=    Evaluate    {{ cellular_gateway_lan.fixed_ip_assignments }}
    ${validated}=    Validate Subset     ${cellular_gateway_lan}[fixedIpAssignments]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_lan.fixed_ip_assignments is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_gateway_lan/reserved_ip_ranges{% if cellular_gateway_lan.reserved_ip_ranges is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellularGateway/lan   ['{{ organization.name }}', '{{ device.name }}']   cellular_gateway_lan
    ${evaluated}=    Evaluate    {{ cellular_gateway_lan.reserved_ip_ranges }}
    ${validated}=    Validate Subset     ${cellular_gateway_lan}[reservedIpRanges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_lan.reserved_ip_ranges is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
