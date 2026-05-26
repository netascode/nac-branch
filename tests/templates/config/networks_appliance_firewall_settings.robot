
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set appliance_firewall = network.appliance.firewall | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/appliance_firewall/settings_spoofing_protection_ip_source_guard_mode{% if appliance_firewall.settings_spoofing_protection_ip_source_guard_mode is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/settings   ['{{ organization.name }}', '{{ network.name }}']   appliance_firewall_settings
    Should Be Equal As Strings   ${appliance_firewall_settings}[spoofingProtection][ipSourceGuard][mode]   {{ appliance_firewall.settings_spoofing_protection_ip_source_guard_mode }}

{% else %}
    Skip    appliance_firewall.settings_spoofing_protection_ip_source_guard_mode is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
