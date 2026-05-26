*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for service in network.appliance.firewall.firewalled_services | default([], true) %}

Verify {{ organization.name }}/networks/{{ network.name }}/appliance_firewall_firewalled_services/{{ service.service_name }} service_name{% if service.service_name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/firewalledServices/{{ service.service_name }}   ['{{ organization.name }}', '{{ network.name }}', '{{ service.service_name }}']   appliance_firewall_firewalled_service
    Should Be Equal As Strings   ${appliance_firewall_firewalled_service}[service]   {{ service.service_name }}

{% else %}
    Skip    service.service_name is not defined
{% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}/appliance_firewall_firewalled_services/{{ service.service_name }} allowed ips{% if service.allowed_ips is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/firewalledServices/{{ service.service_name }}   ['{{ organization.name }}', '{{ network.name }}', '{{ service.service_name }}']   appliance_firewall_firewalled_service
    Should Be Equal As Strings   ${appliance_firewall_firewalled_service}[access]   {{ service.access }}
    {% if service.allowed_ips is defined %}
    ${evaluated}=    Evaluate    {{ service.allowed_ips }}
    ${validated}=    Validate Subset     ${appliance_firewall_firewalled_service}[allowedIps]    ${evaluated}
    Should Be True   ${validated}
    {% endif %}

{% else %}
    Skip    service.allowed_ips is not defined
{% endif %}


Verify {{ organization.name }}/networks/{{ network.name }}/appliance_firewall_firewalled_services/{{ service.service_name }} access {% if service.access is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/appliance/firewall/firewalledServices/{{ service.service_name }}   ['{{ organization.name }}', '{{ network.name }}', '{{ service.service_name }}']   appliance_firewall_firewalled_service
    Should Be Equal As Strings   ${appliance_firewall_firewalled_service}[access]   {{ service.access }}

{% else %}
    Skip    service.access is not defined
{% endif %}

{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
