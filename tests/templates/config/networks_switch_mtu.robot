
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set switch_mtu = network.switch.mtu | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_mtu/default_mtu_size{% if switch_mtu.default_mtu_size is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/mtu   ['{{ organization.name }}', '{{ network.name }}']   switch_mtu
    Should Be Equal As Strings   ${switch_mtu}[defaultMtuSize]   {{ switch_mtu.default_mtu_size }}

{% else %}
    Skip    switch_mtu.default_mtu_size is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/switch_mtu/overrides{% if switch_mtu.overrides is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/mtu   ['{{ organization.name }}', '{{ network.name }}']   switch_mtu
    ${evaluated}=    Evaluate    {{ switch_mtu.overrides }}
    ${validated}=    Validate Subset     ${switch_mtu}[overrides]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    switch_mtu.overrides is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
