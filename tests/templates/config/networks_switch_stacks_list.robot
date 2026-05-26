
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for switch_stack in network.switch_stacks | default([], true) %}
# Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}//id{% if switch_stack.id is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}']   switch_stack
#     Should Be Equal As Strings   ${switch_stack}[id]   {{ switch_stack.id }}

# {% else %}
#     Skip    switch_stack.id is not defined
# {% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}//name{% if switch_stack.name is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}']   switch_stack
    Should Be Equal As Strings   ${switch_stack}[name]   {{ switch_stack.name }}

{% else %}
    Skip    switch_stack.name is not defined
{% endif %}
# Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}//serials{% if switch_stack.serials is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}']   switch_stack
#     ${evaluated}=    Evaluate    {{ switch_stack.serials }}
#     ${validated}=    Validate Subset     ${switch_stack}[serials]    ${evaluated}
#     Should Be True   ${validated}

# {% else %}
#     Skip    switch_stack.serials is not defined
# {% endif %}
# Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}//is_monitor_only{% if switch_stack.is_monitor_only is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}']   switch_stack
#     Should Be Equal As Strings   ${switch_stack}[isMonitorOnly]   {{ switch_stack.is_monitor_only }}

# {% else %}
#     Skip    switch_stack.is_monitor_only is not defined
# {% endif %}
# Verify {{ organization.name }}/networks/{{ network.name }}/switch_stacks/{{ switch_stack.name }}//members{% if switch_stack.members is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/switch/stacks/{switchStackId}   ['{{ organization.name }}', '{{ network.name }}', '{{ switch_stack.name }}']   switch_stack
#     ${evaluated}=    Evaluate    {{ switch_stack.members }}
#     ${validated}=    Validate Subset     ${switch_stack}[members]    ${evaluated}
#     Should Be True   ${validated}

# {% else %}
#     Skip    switch_stack.members is not defined
# {% endif %}

{% endfor %}

{% endfor %}
{% endfor %}
{% endfor %}
