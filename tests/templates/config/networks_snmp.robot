
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set snmp = network.snmp | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/snmp/access{% if snmp.access is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/snmp   ['{{ organization.name }}', '{{ network.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[access]   {{ snmp.access }}

{% else %}
    Skip    snmp.access is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/snmp/community_string{% if snmp.community_string is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/snmp   ['{{ organization.name }}', '{{ network.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[communityString]   {{ snmp.community_string }}

{% else %}
    Skip    snmp.community_string is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/snmp/users{% if snmp.users is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/snmp   ['{{ organization.name }}', '{{ network.name }}']   snmp
    ${evaluated}=    Evaluate    {{ snmp.users }}
    ${validated}=    Validate Subset     ${snmp}[users]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    snmp.users is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
