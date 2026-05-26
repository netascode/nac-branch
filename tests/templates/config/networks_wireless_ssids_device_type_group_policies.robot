
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set device_type_group_policies = wireless_ssid.device_type_group_policies | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/device_type_group_policies/enabled{% if device_type_group_policies.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/deviceTypeGroupPolicies   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   device_type_group_policies
    Should Be Equal As Strings   ${device_type_group_policies}[enabled]   {{ device_type_group_policies.enabled }}

{% else %}
    Skip    device_type_group_policies.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/device_type_group_policies/device_type_policies{% if device_type_group_policies.device_type_policies is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/deviceTypeGroupPolicies   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   device_type_group_policies
    ${evaluated}=    Evaluate    {{ device_type_group_policies.device_type_policies }}
    ${validated}=    Validate Subset     ${device_type_group_policies}[deviceTypePolicies]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    device_type_group_policies.device_type_policies is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
