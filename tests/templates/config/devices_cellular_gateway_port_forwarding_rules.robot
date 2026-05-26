
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.cellular_gateway is defined %}
{% set cellular_gateway_port_forwarding_rules = device.cellular_gateway.port_forwarding_rules | default(none) %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_gateway_port_forwarding_rules{% if cellular_gateway_port_forwarding_rules is not none %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellularGateway/portForwardingRules   ['{{ organization.name }}', '{{ device.name }}']   cellular_gateway_port_forwarding_rules
    ${evaluated}=    Evaluate    {{ cellular_gateway_port_forwarding_rules }}
    ${validated}=    Validate Subset     ${cellular_gateway_port_forwarding_rules}[rules]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_gateway_port_forwarding_rules is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
