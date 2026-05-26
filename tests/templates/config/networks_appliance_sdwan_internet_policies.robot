
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_sdwan_internet_policies = network.appliance.sdwan_internet_policies | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_sdwan_internet_policies/wan_traffic_uplink_preferences{% if appliance_sdwan_internet_policies is not none %}
    # Note: this endpoint requires "has_beta_api" early access features opt-in.
    [Setup]   Get Meraki Data   /organizations/{organizationId}/appliance/sdwan/internetPolicies   ['{{ organization.name }}']   organization_appliance_sdwan_internet_policies
    # Get the network's data from the organization-level response. This response does not match OpenAPI beta spec.
    ${network_appliance_sdwan_internet_policies}=    Get List Item By Key    ${organization_appliance_sdwan_internet_policies}[items]    key=networkName    value={{ network.name }}
    ${evaluated}=    Evaluate    {{ appliance_sdwan_internet_policies }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /networks/{networkId}/appliance/trafficShaping/customPerformanceClasses/{customPerformanceClassId}    ['{{ organization.name }}', '{{ network.name }}']    path=performance_class    name_prop=custom_performance_class_name    id_prop=custom_performance_class_id
    ${validated}=    Validate Subset     ${network_appliance_sdwan_internet_policies}[wanTrafficUplinkPreferences]    ${evaluated}    ['fail_over_criterion', 'preferred_uplink', 'performance_class', 'traffic_filters']
    Should Be True   ${validated}

{% else %}
    Skip    appliance.sdwan_internet_policies is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
