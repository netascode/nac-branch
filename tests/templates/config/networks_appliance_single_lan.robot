
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_single_lan = network.appliance.single_lan | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_single_lan/subnet{% if appliance_single_lan.subnet is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/singleLan   ['{{ organization.name }}', '{{ network.name }}']   appliance_single_lan
    Should Be Equal As Strings   ${appliance_single_lan}[subnet]   {{ appliance_single_lan.subnet }}

{% else %}
    Skip    appliance_single_lan.subnet is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_single_lan/appliance_ip{% if appliance_single_lan.appliance_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/singleLan   ['{{ organization.name }}', '{{ network.name }}']   appliance_single_lan
    Should Be Equal As Strings   ${appliance_single_lan}[applianceIp]   {{ appliance_single_lan.appliance_ip }}

{% else %}
    Skip    appliance_single_lan.appliance_ip is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_single_lan/mandatory_dhcp{% if appliance_single_lan.mandatory_dhcp is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/singleLan   ['{{ organization.name }}', '{{ network.name }}']   appliance_single_lan
    Should Be Equal As Strings   ${appliance_single_lan}[mandatoryDhcp][enabled]   {{ appliance_single_lan.mandatory_dhcp }}

{% else %}
    Skip    appliance_single_lan.mandatory_dhcp is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_single_lan/ipv6{% if appliance_single_lan.ipv6 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/singleLan   ['{{ organization.name }}', '{{ network.name }}']   appliance_single_lan
    ${evaluated}=    Evaluate    {{ appliance_single_lan.ipv6 }}
    ${validated}=    Validate Subset     ${appliance_single_lan}[ipv6]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_single_lan.ipv6 is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
