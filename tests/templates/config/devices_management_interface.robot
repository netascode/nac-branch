
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% set management_interface = device.management_interface | default({}, true) %}
Verify {{ organization.name }}/devices/{{ device.name }}/management_interface/ddns_hostnames{% if management_interface.ddns_hostnames is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/managementInterface   ['{{ organization.name }}', '{{ device.name }}']   management_interface
    ${evaluated}=    Evaluate    {{ management_interface.ddns_hostnames }}
    ${validated}=    Validate Subset     ${management_interface}[ddnsHostnames]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    management_interface.ddns_hostnames is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/management_interface/wan1{% if management_interface.wan1 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/managementInterface   ['{{ organization.name }}', '{{ device.name }}']   management_interface
    ${evaluated}=    Evaluate    {{ management_interface.wan1 }}
    ${validated}=    Validate Subset     ${management_interface}[wan1]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    management_interface.wan1 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/management_interface/wan2{% if management_interface.wan2 is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/managementInterface   ['{{ organization.name }}', '{{ device.name }}']   management_interface
    ${evaluated}=    Evaluate    {{ management_interface.wan2 }}
    ${validated}=    Validate Subset     ${management_interface}[wan2]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    management_interface.wan2 is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/management_interface/lan_ip{% if management_interface.lan_ip is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/managementInterface   ['{{ organization.name }}', '{{ device.name }}']   management_interface
    ${evaluated}=    Evaluate    {{ management_interface.lan_ip }}
    ${validated}=    Validate Subset     ${management_interface}[wan1]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    management_interface.lan_ip is not defined
{% endif %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
