
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}
Verify {{ organization.name }}/devices/{{ device.name }}//name{% if device.name is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[name]   {{ device.name }}

{% else %}
    Skip    device.name is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}//lat{% if device.lat is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[lat]   {{ device.lat }}

{% else %}
    Skip    device.lat is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}//lng{% if device.lng is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[lng]   {{ device.lng }}

{% else %}
    Skip    device.lng is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}//address{% if device.address is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[address]   {{ device.address }}

{% else %}
    Skip    device.address is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}//notes{% if device.notes is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[notes]   {{ device.notes }}

{% else %}
    Skip    device.notes is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}//tags{% if device.tags is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    ${evaluated}=    Evaluate    {{ device.tags }}
    ${validated}=    Validate Subset     ${device}[tags]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    device.tags is not defined
{% endif %}
# Note: networkId is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/devices/{{ device.name }}//serial{% if device.serial is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[serial]   {{ device.serial }}

{% else %}
    Skip    device.serial is not defined
{% endif %}
# Note: model is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: mac is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: lanIp is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: firmware is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/devices/{{ device.name }}//floor_plan_id{% if device.floor_plan_id is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
    Should Be Equal As Strings   ${device}[floorPlanId]   {{ device.floor_plan_id }}

{% else %}
    Skip    device.floor_plan_id is not defined
{% endif %}
# Verify {{ organization.name }}/devices/{{ device.name }}//details{% if device.details is defined %}
#     [Setup]   Get Meraki Data   /devices/{serial}   ['{{ organization.name }}', '{{ device.name }}']   device
#     ${evaluated}=    Evaluate    {{ device.details }}
#     ${validated}=    Validate Subset     ${device}[details]    ${evaluated}
#     Should Be True   ${validated}

# {% else %}
#     Skip    device.details is not defined
# {% endif %}
# Note: beaconIdParams is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
