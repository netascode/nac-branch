
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for webhooks_payload_template in network.webhooks.payload_templates | default([], true) %}

Verify {{ organization.name }}/networks/{{ network.name }}/webhooks_payload_templates/{{ webhooks_payload_template.name }}//name{% if webhooks_payload_template.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/webhooks/payloadTemplates/{payloadTemplateId}   ['{{ organization.name }}', '{{ network.name }}', '{{ webhooks_payload_template.name }}']   webhooks_payload_template
    Should Be Equal As Strings   ${webhooks_payload_template}[name]   {{ webhooks_payload_template.name }}

{% else %}
    Skip    webhooks_payload_template.name is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/webhooks_payload_templates/{{ webhooks_payload_template.name }}//body{% if webhooks_payload_template.body is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/webhooks/payloadTemplates/{payloadTemplateId}   ['{{ organization.name }}', '{{ network.name }}', '{{ webhooks_payload_template.name }}']   webhooks_payload_template
    Should Be Equal As Strings   ${webhooks_payload_template}[body]   {{ webhooks_payload_template.body | normalize_special_string }}

{% else %}
    Skip    webhooks_payload_template.body is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/webhooks_payload_templates/{{ webhooks_payload_template.name }}//headers{% if webhooks_payload_template.headers is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/webhooks/payloadTemplates/{payloadTemplateId}   ['{{ organization.name }}', '{{ network.name }}', '{{ webhooks_payload_template.name }}']   webhooks_payload_template
    ${evaluated}=    Evaluate    {{ webhooks_payload_template.headers }}
    ${validated}=    Validate Subset     ${webhooks_payload_template}[headers]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    webhooks_payload_template.headers is not defined
{% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
