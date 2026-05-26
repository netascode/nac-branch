
*** Settings ***
Library    String
Library    Collections
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}

{% if (network.managed | default(true)) == false %}
{{ organization.name }}/networks/{{ network.name }} (unmanaged)
    Skip    network.managed is false
{% else %}

Verify {{ organization.name }}/networks/{{ network.name }}//name{% if network.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    Should Be Equal As Strings   ${network}[name]   {{ network.name }}
{% else %}
    Skip    network.name is not defined
{% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}//product_types{% if network.product_types is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    ${evaluated}=    Evaluate    {{ network.product_types }}
    # TODO YAML product types have many duplicates - the duplicates in each YAML are not deduplicated, but appended.
    # "terraform plan" output does not have the duplicates.
    ${evaluated}=    Remove Duplicates    ${evaluated}
    ${validated}=    Validate Subset     ${network}[productTypes]    ${evaluated}
    Should Be True   ${validated}
{% else %}
    Skip    network.product_types is not defined
{% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}//time_zone{% if network.time_zone is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    Should Be Equal As Strings   ${network}[timeZone]   {{ network.time_zone }}
{% else %}
    Skip    network.time_zone is not defined
{% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}//tags{% if network.tags is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    ${evaluated}=    Evaluate    {{ network.tags }}
    # TODO YAML tags have many duplicates - the duplicates in each YAML are not deduplicated, but appended.
    # "terraform plan" output does not have the duplicates.
    ${evaluated}=    Remove Duplicates    ${evaluated}
    ${validated}=    Validate Subset     ${network}[tags]    ${evaluated}
    Should Be True   ${validated}
{% else %}
    Skip    network.tags is not defined
{% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}//enrollment_string{% if network.enrollment_string is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    Should Be Equal As Strings   ${network}[enrollmentString]   {{ network.enrollment_string }}
{% else %}
    Skip    network.enrollment_string is not defined
{% endif %}

# Note: url is not checked, as it is only included in the response,
#       but not in the OpenAPI request, hence not in the .nac.yaml schema.

Verify {{ organization.name }}/networks/{{ network.name }}//notes{% if network.notes is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    Should Be Equal As Strings   ${network}[notes]   {{ network.notes }}
{% else %}
    Skip    network.notes is not defined
{% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}//is_bound_to_config_template{% if network.is_bound_to_config_template is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}   ['{{ organization.name }}', '{{ network.name }}']   network
    Should Be Equal As Strings   ${network}[isBoundToConfigTemplate]   {{ network.is_bound_to_config_template }}
{% else %}
    Skip    network.is_bound_to_config_template is not defined
{% endif %}

{% endif %}  {# end managed check #}

{% endfor %}
{% endfor %}
{% endfor %}
