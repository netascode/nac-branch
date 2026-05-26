
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for group_policie in network.group_policies | default([], true) %}

# Note: groupPolicyId is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//scheduling{% if group_policie.scheduling is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    ${evaluated}=    Evaluate    {{ group_policie.scheduling }}
    ${validated}=    Validate Subset     ${group_policie}[scheduling]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    group_policie.scheduling is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//bandwidth{% if group_policie.bandwidth is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    ${evaluated}=    Evaluate    {{ group_policie.bandwidth }}
    ${validated}=    Validate Subset     ${group_policie}[bandwidth]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    group_policie.bandwidth is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//firewall_and_traffic_shaping{% if group_policie.firewall_and_traffic_shaping is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    ${evaluated}=    Evaluate    {{ group_policie.firewall_and_traffic_shaping }}
    ${evaluated}=    Map Application IDs To API    ${evaluated}    path=l7_firewall_rules
    ${evaluated}=    Map Application IDs To API    ${evaluated}    path=traffic_shaping_rules.definitions
    ${validated}=    Validate Subset     ${group_policie}[firewallAndTrafficShaping]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    group_policie.firewall_and_traffic_shaping is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//content_filtering{% if group_policie.content_filtering is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    ${evaluated}=    Evaluate    {{ group_policie.content_filtering }}
    ${validated}=    Validate Subset     ${group_policie}[contentFiltering]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    group_policie.content_filtering is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//splash_auth_settings{% if group_policie.splash_auth_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    Should Be Equal As Strings   ${group_policie}[splashAuthSettings]   {{ group_policie.splash_auth_settings }}

{% else %}
    Skip    group_policie.splash_auth_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//vlan_tagging{% if group_policie.vlan_tagging is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    ${evaluated}=    Evaluate    {{ group_policie.vlan_tagging }}
    ${validated}=    Validate Subset     ${group_policie}[vlanTagging]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    group_policie.vlan_tagging is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/group_policies/{{ group_policie.name }}//bonjour_forwarding{% if group_policie.bonjour_forwarding is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/groupPolicies/{groupPolicyId}   ['{{ organization.name }}', '{{ network.name }}', '{{ group_policie.name }}']   group_policie
    ${evaluated}=    Evaluate    {{ group_policie.bonjour_forwarding }}
    ${validated}=    Validate Subset     ${group_policie}[bonjourForwarding]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    group_policie.bonjour_forwarding is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
