
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set syslog_servers = network.syslog_servers | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/syslog_servers{% if syslog_servers is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/syslogServers   ['{{ organization.name }}', '{{ network.name }}']   syslog_servers
    ${evaluated}=    Evaluate    {{ syslog_servers }}
    ${validated}=    Validate Subset     ${syslog_servers}[servers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    syslog_servers is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
