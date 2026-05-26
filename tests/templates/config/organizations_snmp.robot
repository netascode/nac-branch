
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set snmp = organization.snmp | default({}, true) %}
Verify {{ organization.name }}/snmp/v2c{% if snmp.v2c is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[v2cEnabled]   {{ snmp.v2c }}

{% else %}
    Skip    snmp.v2c is not defined
{% endif %}
Verify {{ organization.name }}/snmp/v2_community_string{% if snmp.v2_community_string is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[v2CommunityString]   {{ snmp.v2_community_string }}

{% else %}
    Skip    snmp.v2_community_string is not defined
{% endif %}
Verify {{ organization.name }}/snmp/v3{% if snmp.v3 is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[v3Enabled]   {{ snmp.v3 }}

{% else %}
    Skip    snmp.v3 is not defined
{% endif %}
Verify {{ organization.name }}/snmp/v3_user{% if snmp.v3_user is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[v3User]   {{ snmp.v3_user }}

{% else %}
    Skip    snmp.v3_user is not defined
{% endif %}
Verify {{ organization.name }}/snmp/v3_auth_mode{% if snmp.v3_auth_mode is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[v3AuthMode]   {{ snmp.v3_auth_mode }}

{% else %}
    Skip    snmp.v3_auth_mode is not defined
{% endif %}
Verify {{ organization.name }}/snmp/v3_priv_mode{% if snmp.v3_priv_mode is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[v3PrivMode]   {{ snmp.v3_priv_mode }}

{% else %}
    Skip    snmp.v3_priv_mode is not defined
{% endif %}
Verify {{ organization.name }}/snmp/peer_ips{% if snmp.peer_ips is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    ${evaluated}=    Evaluate    {{ snmp.peer_ips }}
    ${validated}=    Validate Subset     ${snmp}[peerIps]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    snmp.peer_ips is not defined
{% endif %}
Verify {{ organization.name }}/snmp/hostname{% if snmp.hostname is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[hostname]   {{ snmp.hostname }}

{% else %}
    Skip    snmp.hostname is not defined
{% endif %}
Verify {{ organization.name }}/snmp/port{% if snmp.port is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/snmp   ['{{ organization.name }}']   snmp
    Should Be Equal As Strings   ${snmp}[port]   {{ snmp.port }}

{% else %}
    Skip    snmp.port is not defined
{% endif %}


{% endfor %}
{% endfor %}
