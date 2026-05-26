
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
# create a new dict for switchports expanding port_id_ranges to individual port_ids
{% set appliance_ports_expanded = [] %}
{% for appliance_ports_ranges in network.appliance.ports | default([], true) %}
    {% for appliance_ports_range in appliance_ports_ranges.port_id_ranges %}
        {% for port_id in range(appliance_ports_range.from, appliance_ports_range.to + 1) %}
            {% set a = appliance_ports_ranges.copy() %}
            {% set _ = a.update({'port_id': port_id}) %}
            {% set _ = appliance_ports_expanded.append(a) %}
        {% endfor %}
    {% endfor %}
{% endfor %}
{% for appliance_port in appliance_ports_expanded %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//number{% if appliance_port.number is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[number]   {{ appliance_port.port_id }}

{% else %}
    Skip    appliance_port.number is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//enabled{% if appliance_port.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[enabled]   {{ appliance_port.enabled }}

{% else %}
    Skip    appliance_port.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//type{% if appliance_port.type is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[type]   {{ appliance_port.type }}

{% else %}
    Skip    appliance_port.type is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//drop_untagged_traffic{% if appliance_port.drop_untagged_traffic is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[dropUntaggedTraffic]   {{ appliance_port.drop_untagged_traffic }}

{% else %}
    Skip    appliance_port.drop_untagged_traffic is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//vlan{% if appliance_port.vlan is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[vlan]   {{ appliance_port.vlan }}

{% else %}
    Skip    appliance_port.vlan is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//allowed_vlans{% if appliance_port.allowed_vlans is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[allowedVlans]   {{ appliance_port.allowed_vlans }}

{% else %}
    Skip    appliance_port.allowed_vlans is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ports/{{ appliance_port.port_id }}//access_policy{% if appliance_port.access_policy is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ports/{{ appliance_port.port_id }}   ['{{ organization.name }}', '{{ network.name }}']   appliance_port
    Should Be Equal As Strings   ${appliance_port}[accessPolicy]   {{ appliance_port.access_policy }}

{% else %}
    Skip    appliance_port.access_policy is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
