
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for device in network.devices | default([], true) %}

{% if device.cellular_sims is defined %}
{% set cellular_sims = device.cellular_sims | default({}, true) %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_sims/sims{% if cellular_sims.sims is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellular/sims   ['{{ organization.name }}', '{{ device.name }}']   cellular_sims
    ${evaluated}=    Evaluate    {{ cellular_sims.sims }}
    ${validated}=    Validate Subset     ${cellular_sims}[sims]    ${evaluated}     ['slot', 'is_primary', 'apns.name', 'apns.allowed_ip_types', 'apns.authentication.type', 'apns.authentication.username', 'apns.authentication.password']
    Should Be True   ${validated}

{% else %}
    Skip    cellular_sims.sims is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_sims/sim_ordering{% if cellular_sims.sim_ordering is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellular/sims   ['{{ organization.name }}', '{{ device.name }}']   cellular_sims
    ${evaluated}=    Evaluate    {{ cellular_sims.sim_ordering }}
    ${validated}=    Validate Subset     ${cellular_sims}[simOrdering]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_sims.sim_ordering is not defined
{% endif %}
Verify {{ organization.name }}/devices/{{ device.name }}/cellular_sims/sim_failover{% if cellular_sims.sim_failover is defined %}
    [Setup]   Get Meraki Data   /devices/{serial}/cellular/sims   ['{{ organization.name }}', '{{ device.name }}']   cellular_sims
    ${evaluated}=    Evaluate    {{ cellular_sims.sim_failover }}
    ${validated}=    Validate Subset     ${cellular_sims}[simFailover]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    cellular_sims.sim_failover is not defined
{% endif %}


{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
