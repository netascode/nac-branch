
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for vlan_profile in network.vlan_profiles | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/vlan_profiles/{{ vlan_profile.name }}//iname{% if vlan_profile.iname is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/vlanProfiles/{iname}   ['{{ organization.name }}', '{{ network.name }}', '{{ vlan_profile.name }}']   vlan_profile
    Should Be Equal As Strings   ${vlan_profile}[iname]   {{ vlan_profile.iname }}

{% else %}
    Skip    vlan_profile.iname is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/vlan_profiles/{{ vlan_profile.name }}//name{% if vlan_profile.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/vlanProfiles/{iname}   ['{{ organization.name }}', '{{ network.name }}', '{{ vlan_profile.name }}']   vlan_profile
    Should Be Equal As Strings   ${vlan_profile}[name]   {{ vlan_profile.name }}

{% else %}
    Skip    vlan_profile.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/vlan_profiles/{{ vlan_profile.name }}//is_default{% if vlan_profile.is_default is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/vlanProfiles/{iname}   ['{{ organization.name }}', '{{ network.name }}', '{{ vlan_profile.name }}']   vlan_profile
    Should Be Equal As Strings   ${vlan_profile}[isDefault]   {{ vlan_profile.is_default }}

{% else %}
    Skip    vlan_profile.is_default is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/vlan_profiles/{{ vlan_profile.name }}//vlan_names{% if vlan_profile.vlan_names is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/vlanProfiles/{iname}   ['{{ organization.name }}', '{{ network.name }}', '{{ vlan_profile.name }}']   vlan_profile
    ${evaluated}=    Evaluate    {{ vlan_profile.vlan_names }}
    ${validated}=    Validate Subset     ${vlan_profile}[vlanNames]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    vlan_profile.vlan_names is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/vlan_profiles/{{ vlan_profile.name }}//vlan_groups{% if vlan_profile.vlan_groups is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/vlanProfiles/{iname}   ['{{ organization.name }}', '{{ network.name }}', '{{ vlan_profile.name }}']   vlan_profile
    ${evaluated}=    Evaluate    {{ vlan_profile.vlan_groups }}
    ${validated}=    Validate Subset     ${vlan_profile}[vlanGroups]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    vlan_profile.vlan_groups is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
