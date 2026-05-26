
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_link_aggregations = network.switch.link_aggregations | default(none) %}
Verify Array {{ organization.name }}/networks/{{ network.name }}/switch_link_aggregations switch_link_aggregations{% if switch_link_aggregations is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/linkAggregations   ['{{ organization.name }}', '{{ network.name }}']   switch_link_aggregations
    ${evaluated}=    Evaluate    {{ switch_link_aggregations }}
    ${evaluated}=    Map Names To IDs    ${evaluated}    /devices/{serial}    ['{{ organization.name }}']    path=switch_ports    name_prop=device    id_prop=serial
    # TODO Also include switch_profile_ports when they are implemented.
    ${validated}=    Validate Subset     ${switch_link_aggregations}    ${evaluated}    ['switch_ports']
    Should Be True   ${validated}
{% else %}
    Skip   switch_link_aggregations is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
