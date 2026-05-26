
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_port_schedules = network.switch.port_schedules | default(none) %}
Verify Array {{ organization.name }}/networks/{{ network.name }}/switch_port_schedules switch_port_schedules{% if switch_port_schedules is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/portSchedules   ['{{ organization.name }}', '{{ network.name }}']   switch_port_schedules
    ${evaluated}=    Evaluate    {{ switch_port_schedules }}
    ${validated}=    Validate Subset     ${switch_port_schedules}    ${evaluated}
    Should Be True   ${validated}
{% else %}
    Skip   switch_port_schedules is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
