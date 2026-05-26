
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_routing_multicast = network.switch.routing_multicast | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_multicast/default_settings{% if switch_routing_multicast.default_settings is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_multicast
    ${evaluated}=    Evaluate    {{ switch_routing_multicast.default_settings }}
    ${validated}=    Validate Subset     ${switch_routing_multicast}[defaultSettings]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_multicast.default_settings is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_routing_multicast/overrides{% if switch_routing_multicast.overrides is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/routing/multicast   ['{{ organization.name }}', '{{ network.name }}']   switch_routing_multicast
    ${evaluated}=    Evaluate    {{ switch_routing_multicast.overrides }}
    ${validated}=    Validate Subset     ${switch_routing_multicast}[overrides]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_routing_multicast.overrides is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
