
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_routing_ospf = network.switch.routing_ospf | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/enabled{% if switch_routing_ospf.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    Should Be Equal As Strings   ${switch_routing_ospf}[enabled]   {{ switch_routing_ospf.enabled }}

{% else %}
    Skip    switch_routing_ospf.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/hello_timer_in_seconds{% if switch_routing_ospf.hello_timer_in_seconds is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    Should Be Equal As Strings   ${switch_routing_ospf}[helloTimerInSeconds]   {{ switch_routing_ospf.hello_timer_in_seconds }}

{% else %}
    Skip    switch_routing_ospf.hello_timer_in_seconds is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/dead_timer_in_seconds{% if switch_routing_ospf.dead_timer_in_seconds is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    Should Be Equal As Strings   ${switch_routing_ospf}[deadTimerInSeconds]   {{ switch_routing_ospf.dead_timer_in_seconds }}

{% else %}
    Skip    switch_routing_ospf.dead_timer_in_seconds is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/areas{% if switch_routing_ospf.areas is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    ${evaluated}=    Evaluate    {{ switch_routing_ospf.areas }}
    ${validated}=    Validate Subset     ${switch_routing_ospf}[areas]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_ospf.areas is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/v3{% if switch_routing_ospf.v3 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    ${evaluated}=    Evaluate    {{ switch_routing_ospf.v3 }}
    ${validated}=    Validate Subset     ${switch_routing_ospf}[v3]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_ospf.v3 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/md5_authentication{% if switch_routing_ospf.md5_authentication is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    Should Be Equal As Strings   ${switch_routing_ospf}[md5AuthenticationEnabled]   {{ switch_routing_ospf.md5_authentication }}

{% else %}
    Skip    switch_routing_ospf.md5_authentication is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_ospf/md5_authentication_key{% if switch_routing_ospf.md5_authentication_key is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/ospf   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_ospf
    ${evaluated}=    Evaluate    {{ switch_routing_ospf.md5_authentication_key }}
    ${validated}=    Validate Subset     ${switch_routing_ospf}[md5AuthenticationKey]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_ospf.md5_authentication_key is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
