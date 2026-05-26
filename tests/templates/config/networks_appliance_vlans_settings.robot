
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

Verify {{ organization.name }}/networks/{{ network.name }}/appliance_vlans_settings{% if network.appliance is defined %}
{% set vlans_enabled = network.appliance.vlans | default([], true) | length > 0 %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/vlans/settings   ['{{ organization.name }}', '{{ network.name }}']   appliance_vlans_settings
    Should Be Equal As Strings   ${appliance_vlans_settings}[vlansEnabled]   {{ vlans_enabled }}

{% else %}
    Skip    network.appliance is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
