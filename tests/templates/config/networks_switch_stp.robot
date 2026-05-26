
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_stp = network.switch.stp | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stp/rstp{% if switch_stp.rstp is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stp   ['{{ organization.name }}', '{{ network.name }}']   switch_stp
    Should Be Equal As Strings   ${switch_stp}[rstpEnabled]   {{ switch_stp.rstp }}

{% else %}
    Skip    switch_stp.rstp is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_stp/stp_bridge_priority{% if switch_stp.stp_bridge_priority is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stp   ['{{ organization.name }}', '{{ network.name }}']   switch_stp
    ${switch_stp}=    Group Switch STP By Bridge Priority    ${switch_stp}    path=stpBridgePriority
    ${evaluated}=    Evaluate    {{ switch_stp.stp_bridge_priority }}
    ${evaluated}=    Group Switch STP By Bridge Priority    ${evaluated}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /devices/{serial}    ['{{ organization.name }}']    path=switches
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}/switch/stacks/{switchStackId}    ['{{ organization.name }}', '{{ network.name }}']    path=stacks
    ${validated}=    Validate Subset     ${switch_stp}[stpBridgePriority]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_stp.stp_bridge_priority is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
