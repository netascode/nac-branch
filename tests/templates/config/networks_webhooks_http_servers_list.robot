
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for webhooks_http_server in network.webhooks.http_servers | default([], true) %}

Verify {{ organization.name }}/networks/{{ network.name }}/webhooks_http_servers/{{ webhooks_http_server.name }}//name{% if webhooks_http_server.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/webhooks/httpServers/{httpServerId}   ['{{ organization.name }}', '{{ network.name }}', '{{ webhooks_http_server.name }}']   webhooks_http_server
    Should Be Equal As Strings   ${webhooks_http_server}[name]   {{ webhooks_http_server.name }}

{% else %}
    Skip    webhooks_http_server.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/webhooks_http_servers/{{ webhooks_http_server.name }}//url{% if webhooks_http_server.url is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/webhooks/httpServers/{httpServerId}   ['{{ organization.name }}', '{{ network.name }}', '{{ webhooks_http_server.name }}']   webhooks_http_server
    Should Be Equal As Strings   ${webhooks_http_server}[url]   {{ webhooks_http_server.url }}

{% else %}
    Skip    webhooks_http_server.url is not defined
{% endif %}
# Note: sharedSecret is not checked, as it is not included in the GET response
Verify {{ organization.name }}/networks/{{ network.name }}/webhooks_http_servers/{{ webhooks_http_server.name }}//payload_template{% if webhooks_http_server.payload_template is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/webhooks/httpServers/{httpServerId}   ['{{ organization.name }}', '{{ network.name }}', '{{ webhooks_http_server.name }}']   webhooks_http_server
    ${evaluated}=    Evaluate    {{ webhooks_http_server.payload_template }}
    ${validated}=    Validate Subset     ${webhooks_http_server}[payloadTemplate]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    webhooks_http_server.payload_template is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
