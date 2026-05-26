
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% set settings = network.settings | default({}, true) %}
Verify {{ organization.name }}/networks/{{ network.name }}/settings/local_status_page_enabled{% if settings.local_status_page_enabled is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/settings   ['{{ organization.name }}', '{{ network.name }}']   settings
    Should Be Equal As Strings   ${settings}[localStatusPageEnabled]   {{ settings.local_status_page_enabled }}

{% else %}
    Skip    settings.local_status_page_enabled is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/settings/remote_status_page{% if settings.remote_status_page is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/settings   ['{{ organization.name }}', '{{ network.name }}']   settings
    Should Be Equal As Strings   ${settings}[remoteStatusPageEnabled]   {{ settings.remote_status_page }}

{% else %}
    Skip    settings.remote_status_page is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/settings/local_status_page_authentication{% if settings.local_status_page_authentication is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/settings   ['{{ organization.name }}', '{{ network.name }}']   settings
    ${evaluated}=    Evaluate    {{ settings.local_status_page_authentication }}
    ${validated}=    Validate Subset     ${settings}[localStatusPage][authentication]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    settings.local_status_page_authentication is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/settings/secure_port{% if settings.secure_port is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/settings   ['{{ organization.name }}', '{{ network.name }}']   settings
    Should Be Equal As Strings   ${settings}[securePort][enabled]   {{ settings.secure_port }}

{% else %}
    Skip    settings.secure_port is not defined
{% endif %}
# Note: fips is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.
Verify {{ organization.name }}/networks/{{ network.name }}/settings/named_vlans{% if settings.named_vlans is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/settings   ['{{ organization.name }}', '{{ network.name }}']   settings
    Should Be Equal As Strings   ${settings}[namedVlans][enabled]   {{ settings.named_vlans }}

{% else %}
    Skip    settings.named_vlans is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
