
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_dscp_to_cos_mappings = network.switch.dscp_to_cos_mappings | default(none) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_dscp_to_cos_mappings{% if switch_dscp_to_cos_mappings is not none %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/dscpToCosMappings   ['{{ organization.name }}', '{{ network.name }}']   switch_dscp_to_cos_mappings
    ${evaluated}=    Evaluate    {{ switch_dscp_to_cos_mappings }}
    ${validated}=    Validate Subset     ${switch_dscp_to_cos_mappings}[mappings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_dscp_to_cos_mappings is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
