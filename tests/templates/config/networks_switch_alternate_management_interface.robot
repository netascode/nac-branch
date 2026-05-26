
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_alternate_management_interface = network.switch.alternate_management_interface | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_alternate_management_interface/enabled{% if switch_alternate_management_interface.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   switch_alternate_management_interface
    Should Be Equal As Strings   ${switch_alternate_management_interface}[enabled]   {{ switch_alternate_management_interface.enabled }}
    Set Suite Variable    ${enabled}   {{ switch_alternate_management_interface.enabled }}

{% else %}
    Skip    switch_alternate_management_interface.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_alternate_management_interface/vlan_id{% if switch_alternate_management_interface.vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   switch_alternate_management_interface
    Skip If    ${enabled} == False     switch alternate management interface disabled, not running checks
    Should Be Equal As Strings   ${switch_alternate_management_interface}[vlanId]   {{ switch_alternate_management_interface.vlan_id }}

{% else %}
    Skip    switch_alternate_management_interface.vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_alternate_management_interface/protocols{% if switch_alternate_management_interface.protocols is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   switch_alternate_management_interface
    Skip If    ${enabled} == False     switch alternate management interface disabled, not running checks
    ${evaluated}=    Evaluate    {{ switch_alternate_management_interface.protocols }}
    ${validated}=    Validate Subset     ${switch_alternate_management_interface}[protocols]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_alternate_management_interface.protocols is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_alternate_management_interface/switches{% if switch_alternate_management_interface.switches is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   switch_alternate_management_interface
    Skip If    ${enabled} == False     switch alternate management interface disabled, not running checks
    ${evaluated}=    Evaluate    {{ switch_alternate_management_interface.switches }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /devices/{serial}    ['{{ organization.name }}']    name_prop=device    id_prop=serial
    ${validated}=    Validate Subset     ${switch_alternate_management_interface}[switches]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_alternate_management_interface.switches is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
