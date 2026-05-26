
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_content_filtering = network.appliance.content_filtering | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.content_filtering/allowed_url_patterns{% if appliance_content_filtering.allowed_url_patterns is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/contentFiltering   ['{{ organization.name }}', '{{ network.name }}']   appliance_content_filtering
    ${evaluated}=    Evaluate    {{ appliance_content_filtering.allowed_url_patterns }}
    ${validated}=    Validate Subset     ${appliance_content_filtering}[allowedUrlPatterns]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.content_filtering.allowed_url_patterns is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.content_filtering/blocked_url_patterns{% if appliance_content_filtering.blocked_url_patterns is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/contentFiltering   ['{{ organization.name }}', '{{ network.name }}']   appliance_content_filtering
    ${evaluated}=    Evaluate    {{ appliance_content_filtering.blocked_url_patterns }}
    ${validated}=    Validate Subset     ${appliance_content_filtering}[blockedUrlPatterns]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.content_filtering.blocked_url_patterns is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance.content_filtering/blocked_url_categories{% if appliance_content_filtering.blocked_url_categories is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/contentFiltering   ['{{ organization.name }}', '{{ network.name }}']   appliance_content_filtering
    ${evaluated}=    Evaluate    {{ appliance_content_filtering.blocked_url_categories }}
    ${evaluated}=    Unflatten Dicts    ${evaluated}    add_key=id
    ${validated}=    Validate Subset     ${appliance_content_filtering}[blockedUrlCategories]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance.content_filtering.blocked_url_categories is not defined
{% endif %}
# TODO urlCategoryListSize is not returned from the GET request
#      despite it being shown in the OpenAPI example response.


{% endfor %}
{% endfor %}
{% endfor %}
