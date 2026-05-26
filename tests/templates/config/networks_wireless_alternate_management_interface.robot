
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set wireless_alternate_management_interface = network.wireless.alternate_management_interface | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_alternate_management_interface/enabled{% if wireless_alternate_management_interface.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   wireless_alternate_management_interface
    Should Be Equal As Strings   ${wireless_alternate_management_interface}[enabled]   {{ wireless_alternate_management_interface.enabled }}

{% else %}
    Skip    wireless_alternate_management_interface.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_alternate_management_interface/vlan_id{% if wireless_alternate_management_interface.vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   wireless_alternate_management_interface
    Should Be Equal As Strings   ${wireless_alternate_management_interface}[vlanId]   {{ wireless_alternate_management_interface.vlan_id }}

{% else %}
    Skip    wireless_alternate_management_interface.vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_alternate_management_interface/protocols{% if wireless_alternate_management_interface.protocols is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   wireless_alternate_management_interface
    ${evaluated}=    Evaluate    {{ wireless_alternate_management_interface.protocols }}
    ${validated}=    Validate Subset     ${wireless_alternate_management_interface}[protocols]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_alternate_management_interface.protocols is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless_alternate_management_interface/access_points{% if wireless_alternate_management_interface.access_points is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/alternateManagementInterface   ['{{ organization.name }}', '{{ network.name }}']   wireless_alternate_management_interface
    ${evaluated}=    Evaluate    {{ wireless_alternate_management_interface.access_points }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /devices/{serial}    ['{{ organization.name }}']    name_prop=device    id_prop=serial
    ${validated}=    Validate Subset     ${wireless_alternate_management_interface}[accessPoints]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    wireless_alternate_management_interface.access_points is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
