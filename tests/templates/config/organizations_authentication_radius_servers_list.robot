
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for authentication_radius_server in organization.authentication_radius_servers | default([], true) %}
Verify {{ organization.name }}/authentication_radius_servers/{{ authentication_radius_server.name }}//name{% if authentication_radius_server.name is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/auth/radius/servers/{serverId}   ['{{ organization.name }}', '{{ authentication_radius_server.name }}']   authentication_radius_server
    Should Be Equal As Strings   ${authentication_radius_server}[name]   {{ authentication_radius_server.name }}

{% else %}
    Skip    authentication_radius_server.name is not defined
{% endif %}
Verify {{ organization.name }}/authentication_radius_servers/{{ authentication_radius_server.name }}//address{% if authentication_radius_server.address is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/auth/radius/servers/{serverId}   ['{{ organization.name }}', '{{ authentication_radius_server.name }}']   authentication_radius_server
    Should Be Equal As Strings   ${authentication_radius_server}[address]   {{ authentication_radius_server.address }}

{% else %}
    Skip    authentication_radius_server.address is not defined
{% endif %}
Verify {{ organization.name }}/authentication_radius_servers/{{ authentication_radius_server.name }}//modes{% if authentication_radius_server.modes is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/auth/radius/servers/{serverId}   ['{{ organization.name }}', '{{ authentication_radius_server.name }}']   authentication_radius_server
    ${evaluated}=    Evaluate    {{ authentication_radius_server.modes }}
    ${validated}=    Validate Subset     ${authentication_radius_server}[modes]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    authentication_radius_server.modes is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
