
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for switch_access_policie in network.switch.access_policies | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//name{% if switch_access_policie.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[name]   {{ switch_access_policie.name }}

{% else %}
    Skip    switch_access_policie.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius_servers{% if switch_access_policie.radius_servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    ${evaluated}=    Evaluate    {{ switch_access_policie.radius_servers }}
    ${validated}=    Validate Subset     ${switch_access_policie}[radiusServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_policie.radius_servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius{% if switch_access_policie.radius is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    ${evaluated}=    Evaluate    {{ switch_access_policie.radius }}
    ${validated}=    Validate Subset     ${switch_access_policie}[radius]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_policie.radius is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//guest_port_bouncing{% if switch_access_policie.guest_port_bouncing is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[guestPortBouncing]   {{ switch_access_policie.guest_port_bouncing }}

{% else %}
    Skip    switch_access_policie.guest_port_bouncing is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius_testing{% if switch_access_policie.radius_testing is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[radiusTestingEnabled]   {{ switch_access_policie.radius_testing }}

{% else %}
    Skip    switch_access_policie.radius_testing is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius_coa_support{% if switch_access_policie.radius_coa_support is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[radiusCoaSupportEnabled]   {{ switch_access_policie.radius_coa_support }}

{% else %}
    Skip    switch_access_policie.radius_coa_support is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius_accounting{% if switch_access_policie.radius_accounting is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[radiusAccountingEnabled]   {{ switch_access_policie.radius_accounting }}

{% else %}
    Skip    switch_access_policie.radius_accounting is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius_accounting_servers{% if switch_access_policie.radius_accounting_servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    ${evaluated}=    Evaluate    {{ switch_access_policie.radius_accounting_servers }}
    ${validated}=    Validate Subset     ${switch_access_policie}[radiusAccountingServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_policie.radius_accounting_servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//radius_group_attribute{% if switch_access_policie.radius_group_attribute is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   "${switch_access_policie}[radiusGroupAttribute]"   "{{ switch_access_policie.radius_group_attribute }}"

{% else %}
    Skip    switch_access_policie.radius_group_attribute is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//host_mode{% if switch_access_policie.host_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[hostMode]   {{ switch_access_policie.host_mode }}

{% else %}
    Skip    switch_access_policie.host_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//access_policy_type{% if switch_access_policie.access_policy_type is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[accessPolicyType]   {{ switch_access_policie.access_policy_type }}

{% else %}
    Skip    switch_access_policie.access_policy_type is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//increase_access_speed{% if switch_access_policie.increase_access_speed is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[increaseAccessSpeed]   {{ switch_access_policie.increase_access_speed }}

{% else %}
    Skip    switch_access_policie.increase_access_speed is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//guest_vlan_id{% if switch_access_policie.guest_vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[guestVlanId]   {{ switch_access_policie.guest_vlan_id }}

{% else %}
    Skip    switch_access_policie.guest_vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//dot1x{% if switch_access_policie.dot1x is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    ${evaluated}=    Evaluate    {{ switch_access_policie.dot1x }}
    ${validated}=    Validate Subset     ${switch_access_policie}[dot1x]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_policie.dot1x is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//voice_vlan_clients{% if switch_access_policie.voice_vlan_clients is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[voiceVlanClients]   {{ switch_access_policie.voice_vlan_clients }}

{% else %}
    Skip    switch_access_policie.voice_vlan_clients is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//url_redirect_walled_garden{% if switch_access_policie.url_redirect_walled_garden is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    Should Be Equal As Strings   ${switch_access_policie}[urlRedirectWalledGardenEnabled]   {{ switch_access_policie.url_redirect_walled_garden }}

{% else %}
    Skip    switch_access_policie.url_redirect_walled_garden is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//url_redirect_walled_garden_ranges{% if switch_access_policie.url_redirect_walled_garden_ranges is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    ${evaluated}=    Evaluate    {{ switch_access_policie.url_redirect_walled_garden_ranges }}
    ${validated}=    Validate Subset     ${switch_access_policie}[urlRedirectWalledGardenRanges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_policie.url_redirect_walled_garden_ranges is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_access_policies/{{ switch_access_policie.name }}//counts{% if switch_access_policie.counts is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/accessPolicies/{accessPolicyNumber}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_access_policie.name }}']   switch_access_policie
    ${evaluated}=    Evaluate    {{ switch_access_policie.counts }}
    ${validated}=    Validate Subset     ${switch_access_policie}[counts]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_access_policie.counts is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
