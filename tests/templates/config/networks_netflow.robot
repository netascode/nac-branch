
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set netflow = network.netflow | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/netflow/reporting{% if netflow.reporting is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/netflow   ['{{ organization.name }}', '{{ network.name }}']   netflow
    Should Be Equal As Strings   ${netflow}[reportingEnabled]   {{ netflow.reporting }}

{% else %}
    Skip    netflow.reporting is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/netflow/collector_ip{% if netflow.collector_ip is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/netflow   ['{{ organization.name }}', '{{ network.name }}']   netflow
    Should Be Equal As Strings   ${netflow}[collectorIp]   {{ netflow.collector_ip }}

{% else %}
    Skip    netflow.collector_ip is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/netflow/collector_port{% if netflow.collector_port is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/netflow   ['{{ organization.name }}', '{{ network.name }}']   netflow
    Should Be Equal As Strings   ${netflow}[collectorPort]   {{ netflow.collector_port }}

{% else %}
    Skip    netflow.collector_port is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/netflow/eta{% if netflow.eta is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/netflow   ['{{ organization.name }}', '{{ network.name }}']   netflow
    Should Be Equal As Strings   ${netflow}[etaEnabled]   {{ netflow.eta }}

{% else %}
    Skip    netflow.eta is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/netflow/eta_destination_port{% if netflow.eta_destination_port is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/netflow   ['{{ organization.name }}', '{{ network.name }}']   netflow
    Should Be Equal As Strings   ${netflow}[etaDstPort]   {{ netflow.eta_destination_port }}

{% else %}
    Skip    netflow.eta_destination_port is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
