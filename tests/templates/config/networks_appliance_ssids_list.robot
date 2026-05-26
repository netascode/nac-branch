
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for appliance_ssid in network.appliance.ssids | default([], true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//number{% if appliance_ssid.number is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[number]   {{ appliance_ssid.number }}

{% else %}
    Skip    appliance_ssid.number is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//name{% if appliance_ssid.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[name]   {{ appliance_ssid.name }}

{% else %}
    Skip    appliance_ssid.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//enabled{% if appliance_ssid.enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[enabled]   {{ appliance_ssid.enabled }}

{% else %}
    Skip    appliance_ssid.enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//default_vlan_id{% if appliance_ssid.default_vlan_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[defaultVlanId]   {{ appliance_ssid.default_vlan_id }}

{% else %}
    Skip    appliance_ssid.default_vlan_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//auth_mode{% if appliance_ssid.auth_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[authMode]   {{ appliance_ssid.auth_mode }}

{% else %}
    Skip    appliance_ssid.auth_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//radius_servers{% if appliance_ssid.radius_servers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    ${evaluated}=    Evaluate    {{ appliance_ssid.radius_servers }}
    ${validated}=    Validate Subset     ${appliance_ssid}[radiusServers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    appliance_ssid.radius_servers is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//encryption_mode{% if appliance_ssid.encryption_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[encryptionMode]   {{ appliance_ssid.encryption_mode }}

{% else %}
    Skip    appliance_ssid.encryption_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//wpa_encryption_mode{% if appliance_ssid.wpa_encryption_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[wpaEncryptionMode]   {{ appliance_ssid.wpa_encryption_mode }}

{% else %}
    Skip    appliance_ssid.wpa_encryption_mode is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_ssids/{{ appliance_ssid.name }}//visible{% if appliance_ssid.visible is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/ssids/{number}   ['{{ organization.name }}', '{{ network.name }}', '{{ appliance_ssid.name }}']   appliance_ssid
    Should Be Equal As Strings   ${appliance_ssid}[visible]   {{ appliance_ssid.visible }}

{% else %}
    Skip    appliance_ssid.visible is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
