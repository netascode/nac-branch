
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for appliance_static_route in network.appliance.static_routes | default([], true) %}
# Note: id is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: ipVersion is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
# Note: ipVersion is not checked, as it is already part of the URI.
# Note: enabled is not checked, as it is only included in the response (and the PUT request),
#       but not in the OpenAPI POST request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_static_routes/{{ appliance_static_route.name }}//name{% if appliance_static_route.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_static_route.name }}']   appliance_static_route
    Should Be Equal As Strings   ${appliance_static_route}[name]   {{ appliance_static_route.name }}

{% else %}
    Skip    appliance_static_route.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_static_routes/{{ appliance_static_route.name }}//subnet{% if appliance_static_route.subnet is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_static_route.name }}']   appliance_static_route
    Should Be Equal As Strings   ${appliance_static_route}[subnet]   {{ appliance_static_route.subnet }}

{% else %}
    Skip    appliance_static_route.subnet is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_static_routes/{{ appliance_static_route.name }}//gateway_ip{% if appliance_static_route.gateway_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_static_route.name }}']   appliance_static_route
    Should Be Equal As Strings   ${appliance_static_route}[gatewayIp]   {{ appliance_static_route.gateway_ip }}

{% else %}
    Skip    appliance_static_route.gateway_ip is not defined
{% endif %}
# Note: fixedIpAssignments is not checked, as it is only included in the response (and the PUT request),
#       but not in the OpenAPI POST request, hence not in the .nac.yaml schema.
# Note: reservedIpRanges is not checked, as it is only included in the response (and the PUT request),
#       but not in the OpenAPI POST request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_static_routes/{{ appliance_static_route.name }}//gateway_vlan_id{% if appliance_static_route.gateway_vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/staticRoutes/{staticRouteId}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_static_route.name }}']   appliance_static_route
    Should Be Equal As Strings   ${appliance_static_route}[gatewayVlanId]   {{ appliance_static_route.gateway_vlan_id }}

{% else %}
    Skip    appliance_static_route.gateway_vlan_id is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
