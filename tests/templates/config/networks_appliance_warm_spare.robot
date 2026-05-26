
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_warm_spare = network.appliance.warm_spare | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/enabled{% if appliance_warm_spare.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
    Should Be Equal As Strings   ${appliance_warm_spare}[enabled]   {{ appliance_warm_spare.enabled }}

{% else %}
    Skip    appliance_warm_spare.enabled is not defined
{% endif %}
#Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/primary_serial{% if appliance_warm_spare.primary_serial is defined %}
#    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
#    Should Be Equal As Strings   ${appliance_warm_spare}[primarySerial]   {{ appliance_warm_spare.primary_serial }}

#{% else %}
#    Skip    appliance_warm_spare.primary_serial is not defined
#{% endif %}
#Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/spare_serial{% if appliance_warm_spare.spare_serial is defined %}
#    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
#    Should Be Equal As Strings   ${appliance_warm_spare}[spareSerial]   {{ appliance_warm_spare.spare_serial }}

#{% else %}
#    Skip    appliance_warm_spare.spare_serial is not defined
#{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/uplink_mode{% if appliance_warm_spare.uplink_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
    Should Be Equal As Strings   ${appliance_warm_spare}[uplinkMode]   {{ appliance_warm_spare.uplink_mode }}

{% else %}
    Skip    appliance_warm_spare.uplink_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/wan1{% if appliance_warm_spare.wan1 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
    ${evaluated}=    Evaluate    {{ appliance_warm_spare.wan1 }}
    ${validated}=    Validate Subset     ${appliance_warm_spare}[wan1]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_warm_spare.wan1 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/wan2{% if appliance_warm_spare.wan2 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
    ${evaluated}=    Evaluate    {{ appliance_warm_spare.wan2 }}
    ${validated}=    Validate Subset     ${appliance_warm_spare}[wan2]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_warm_spare.wan2 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/virtual_ip1{% if appliance_warm_spare.virtual_ip1 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
    Should Be Equal As Strings   ${appliance_warm_spare}[wan1][ip]   {{ appliance_warm_spare.virtual_ip1 }}


{% else %}
    Skip    appliance_warm_spare.virtual_ip1 is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_warm_spare/virtual_ip2{% if appliance_warm_spare.virtual_ip2 is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/warmSpare   ['{{ organization.name }}', '{{ network.name }}']   appliance_warm_spare
    Should Be Equal As Strings   ${appliance_warm_spare}[wan2][ip]   {{ appliance_warm_spare.virtual_ip2 }}


{% else %}
    Skip    appliance_warm_spare.virtual_ip2 is not defined
{% endif %}

{% endfor %}
{% endfor %}
{% endfor %}
