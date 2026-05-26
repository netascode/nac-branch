
*** Settings ***
Library    String
Library    Collections
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}
# create a new dict for switchports expanding port_id_ranges to individual port_ids
{% set switch_ports_expanded = [] %}
{% for switch_ports_ranges in device.switch.ports | default([], true) %}
    {% for switch_ports_range in switch_ports_ranges.port_id_ranges %}
        {% for port_id in range(switch_ports_range.from, switch_ports_range.to + 1) %}
            {% if switch_ports_range.slot is defined and switch_ports_range.module is defined %}
                {% set resolved_port_id = switch_ports_range.slot | string + '_' + switch_ports_range.module | string + '_' + port_id | string %}
            {% else %}
                {% set resolved_port_id = port_id %}
            {% endif %}
            {% set s = switch_ports_ranges.copy() %}
            {% set _ = s.update({'port_id': resolved_port_id}) %}
            {% set _ = switch_ports_expanded.append(s) %}
        {% endfor %}
    {% endfor %}
{% endfor %}
{% for switch_port in switch_ports_expanded %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//port_id{% if switch_port.port_id is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[portId]   {{ switch_port.port_id }}

{% else %}
    Skip    switch_port.port_id is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//name{% if switch_port.name is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[name]   {{ switch_port.name }}

{% else %}
    Skip    switch_port.name is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//tags{% if switch_port.tags is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.tags }}
    # TODO YAML tags have many duplicates - the tags in each port are not deduplicated, but appended.
    # "terraform plan" output does not have the duplicates.
    ${evaluated}=    Remove Duplicates    ${evaluated}
    ${validated}=    Validate Subset     ${switch_port}[tags]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.tags is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//enabled{% if switch_port.enabled is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[enabled]   {{ switch_port.enabled }}

{% else %}
    Skip    switch_port.enabled is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//poe_enabled{% if switch_port.poe_enabled is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[poeEnabled]   {{ switch_port.poe_enabled }}

{% else %}
    Skip    switch_port.poe_enabled is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//type{% if switch_port.type is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[type]   {{ switch_port.type }}

{% else %}
    Skip    switch_port.type is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//vlan{% if switch_port.vlan is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[vlan]   {{ switch_port.vlan }}

{% else %}
    Skip    switch_port.vlan is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//voice_vlan{% if switch_port.voice_vlan is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[voiceVlan]   {{ switch_port.voice_vlan }}

{% else %}
    Skip    switch_port.voice_vlan is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//allowed_vlans{% if switch_port.allowed_vlans is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[allowedVlans]   {{ switch_port.allowed_vlans }}

{% else %}
    Skip    switch_port.allowed_vlans is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//isolation_enabled{% if switch_port.isolation_enabled is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[isolationEnabled]   {{ switch_port.isolation_enabled }}

{% else %}
    Skip    switch_port.isolation_enabled is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//rstp_enabled{% if switch_port.rstp_enabled is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[rstpEnabled]   {{ switch_port.rstp_enabled }}

{% else %}
    Skip    switch_port.rstp_enabled is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//stp_guard{% if switch_port.stp_guard is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[stpGuard]   {{ switch_port.stp_guard }}

{% else %}
    Skip    switch_port.stp_guard is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//link_negotiation{% if switch_port.link_negotiation is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[linkNegotiation]   {{ switch_port.link_negotiation }}

{% else %}
    Skip    switch_port.link_negotiation is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//link_negotiation_capabilities{% if switch_port.link_negotiation_capabilities is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.link_negotiation_capabilities }}
    ${validated}=    Validate Subset     ${switch_port}[linkNegotiationCapabilities]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.link_negotiation_capabilities is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//port_schedule_id{% if switch_port.port_schedule_id is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[portScheduleId]   {{ switch_port.port_schedule_id }}

{% else %}
    Skip    switch_port.port_schedule_id is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//schedule{% if switch_port.schedule is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.schedule }}
    ${validated}=    Validate Subset     ${switch_port}[schedule]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.schedule is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//udld{% if switch_port.udld is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[udld]   {{ switch_port.udld }}

{% else %}
    Skip    switch_port.udld is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//access_policy_type{% if switch_port.access_policy_type is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[accessPolicyType]   {{ switch_port.access_policy_type }}

{% else %}
    Skip    switch_port.access_policy_type is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//access_policy_number{% if switch_port.access_policy_number is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[accessPolicyNumber]   {{ switch_port.access_policy_number }}

{% else %}
    Skip    switch_port.access_policy_number is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//mac_allow_list{% if switch_port.mac_allow_list is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.mac_allow_list }}
    ${validated}=    Validate Subset     ${switch_port}[macAllowList]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.mac_allow_list is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//sticky_mac_allow_list{% if switch_port.sticky_mac_allow_list is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.sticky_mac_allow_list }}
    ${validated}=    Validate Subset     ${switch_port}[stickyMacAllowList]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.sticky_mac_allow_list is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//sticky_mac_allow_list_limit{% if switch_port.sticky_mac_allow_list_limit is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[stickyMacAllowListLimit]   {{ switch_port.sticky_mac_allow_list_limit }}

{% else %}
    Skip    switch_port.sticky_mac_allow_list_limit is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//storm_control_enabled{% if switch_port.storm_control_enabled is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[stormControlEnabled]   {{ switch_port.storm_control_enabled }}

{% else %}
    Skip    switch_port.storm_control_enabled is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//adaptive_policy_group_id{% if switch_port.adaptive_policy_group_id is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[adaptivePolicyGroupId]   {{ switch_port.adaptive_policy_group_id }}

{% else %}
    Skip    switch_port.adaptive_policy_group_id is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//adaptive_policy_group{% if switch_port.adaptive_policy_group is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.adaptive_policy_group }}
    ${validated}=    Validate Subset     ${switch_port}[adaptivePolicyGroup]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.adaptive_policy_group is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//peer_sgt_capable{% if switch_port.peer_sgt_capable is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[peerSgtCapable]   {{ switch_port.peer_sgt_capable }}

{% else %}
    Skip    switch_port.peer_sgt_capable is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//flexible_stacking_enabled{% if switch_port.flexible_stacking_enabled is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[flexibleStackingEnabled]   {{ switch_port.flexible_stacking_enabled }}

{% else %}
    Skip    switch_port.flexible_stacking_enabled is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//dai_trusted{% if switch_port.dai_trusted is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[daiTrusted]   {{ switch_port.dai_trusted }}

{% else %}
    Skip    switch_port.dai_trusted is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//profile{% if switch_port.profile is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.profile }}
    ${validated}=    Validate Subset     ${switch_port}[profile]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.profile is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//module{% if switch_port.module is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.module }}
    ${validated}=    Validate Subset     ${switch_port}[module]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.module is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//mirror{% if switch_port.mirror is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.mirror }}
    ${validated}=    Validate Subset     ${switch_port}[mirror]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.mirror is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//dot3az{% if switch_port.dot3az is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    Should Be Equal As Strings   ${switch_port}[dot3az][enabled]   {{ switch_port.dot3az }}

{% else %}
    Skip    switch_port.dot3az is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/switch_ports/{{ switch_port.port_id }}//stackwise_virtual{% if switch_port.stackwise_virtual is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/switch/ports/{{ switch_port.port_id }}   ['{{ organization.name }}', '{{ device.name }}']   switch_port
    ${evaluated}=    Evaluate    {{ switch_port.stackwise_virtual }}
    ${validated}=    Validate Subset     ${switch_port}[stackwiseVirtual]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_port.stackwise_virtual is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
