
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for floor_plan in network.floor_plans | default([], true) %}

# Note: the following are not checked, as they are only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema:
#       - floorPlanId
#       - imageUrl
#       - imageUrlExpiresAt
#       - imageExtension
#       - imageMd5
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/floor_plans/{{ floor_plan.name }}//name{% if floor_plan.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/floorPlans/{floorPlanId}   ['{{organization.name}}', '{{ network.name }}', '{{ floor_plan.name }}']   floor_plan
    Should Be Equal As Strings   ${floor_plan}[name]   {{ floor_plan.name }}

{% else %}
    Skip    floor_plan.name is not defined
{% endif %}
# Note: the following are not checked, as they are only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema:
#       - devices
#       - width
#       - height
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/floor_plans/{{ floor_plan.name }}//center{% if floor_plan.center is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/floorPlans/{floorPlanId}   ['{{organization.name}}', '{{ network.name }}', '{{ floor_plan.name }}']   floor_plan
    ${evaluated}=    Evaluate    {{ floor_plan.center }}
    ${str1}=         Convert To String    ${evaluated}[lat]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[center][lat]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}
    ${str1}=         Convert To String    ${evaluated}[lng]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[center][lng]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}

{% else %}
    Skip    floor_plan.center is not defined
{% endif %}
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/floor_plans/{{ floor_plan.name }}//bottom_left_corner{% if floor_plan.bottom_left_corner is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/floorPlans/{floorPlanId}   ['{{organization.name}}', '{{ network.name }}', '{{ floor_plan.name }}']   floor_plan
    ${evaluated}=    Evaluate    {{ floor_plan.bottom_left_corner }}
    ${str1}=         Convert To String    ${evaluated}[lat]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[bottomLeftCorner][lat]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}
    ${str1}=         Convert To String    ${evaluated}[lng]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[bottomLeftCorner][lng]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}

{% else %}
    Skip    floor_plan.bottom_left_corner is not defined
{% endif %}
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/floor_plans/{{ floor_plan.name }}//bottom_right_corner{% if floor_plan.bottom_right_corner is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/floorPlans/{floorPlanId}   ['{{organization.name}}', '{{ network.name }}', '{{ floor_plan.name }}']   floor_plan
    ${evaluated}=    Evaluate    {{ floor_plan.bottom_right_corner }}
    ${str1}=         Convert To String    ${evaluated}[lat]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[bottomRightCorner][lat]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}
    ${str1}=         Convert To String    ${evaluated}[lng]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[bottomRightCorner][lng]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}

{% else %}
    Skip    floor_plan.bottom_right_corner is not defined
{% endif %}
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/floor_plans/{{ floor_plan.name }}//top_left_corner{% if floor_plan.top_left_corner is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/floorPlans/{floorPlanId}   ['{{organization.name}}', '{{ network.name }}', '{{ floor_plan.name }}']   floor_plan
    ${evaluated}=    Evaluate    {{ floor_plan.top_left_corner }}
    ${str1}=         Convert To String    ${evaluated}[lat]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[topLeftCorner][lat]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}
    ${str1}=         Convert To String    ${evaluated}[lng]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[topLeftCorner][lng]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}

{% else %}
    Skip    floor_plan.top_left_corner is not defined
{% endif %}
Verify {{domain.name}}/{{organization.name}}/networks/{{ network.name }}/floor_plans/{{ floor_plan.name }}//top_right_corner{% if floor_plan.top_right_corner is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/floorPlans/{floorPlanId}   ['{{organization.name}}', '{{ network.name }}', '{{ floor_plan.name }}']   floor_plan
    ${evaluated}=    Evaluate    {{ floor_plan.top_right_corner }}
    ${str1}=         Convert To String    ${evaluated}[lat]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[topRightCorner][lat]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}
    ${str1}=         Convert To String    ${evaluated}[lng]
    ${prefix1}=      Get Substring    ${str1}    0    6
    ${str2}=         Convert To String     ${floor_plan}[topRightCorner][lng]
    ${prefix2}=      Get Substring    ${str2}     0     6
    Should Be Equal As Strings    ${prefix1}    ${prefix2}

{% else %}
    Skip    floor_plan.top_right_corner is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
