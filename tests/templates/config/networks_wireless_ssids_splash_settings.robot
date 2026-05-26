
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}
{% for network in organization.networks | default([], true) %}
{% for wireless_ssid in network.wireless.ssids | default([], true) %}

{% set splash_settings = wireless_ssid.splash_settings | default({}, true) %}
# Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/ssid_number{% if splash_settings.ssid_number is defined %}
#     [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
#     Should Be Equal As Strings   ${splash_settings}[ssidNumber]   {{ splash_settings.ssid_number }}

# {% else %}
#     Skip    splash_settings.ssid_number is not defined
# {% endif %}

Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/splash_page{% if splash_settings.splash_page is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[splashPage]   {{ splash_settings.splash_page }}

{% else %}
    Skip    splash_settings.splash_page is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/use_splash_url{% if splash_settings.use_splash_url is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[useSplashUrl]   {{ splash_settings.use_splash_url }}

{% else %}
    Skip    splash_settings.use_splash_url is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/splash_url{% if splash_settings.splash_url is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[splashUrl]   {{ splash_settings.splash_url }}

{% else %}
    Skip    splash_settings.splash_url is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/splash_timeout{% if splash_settings.splash_timeout is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[splashTimeout]   {{ splash_settings.splash_timeout }}

{% else %}
    Skip    splash_settings.splash_timeout is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/redirect_url{% if splash_settings.redirect_url is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[redirectUrl]   {{ splash_settings.redirect_url }}

{% else %}
    Skip    splash_settings.redirect_url is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/use_redirect_url{% if splash_settings.use_redirect_url is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[useRedirectUrl]   {{ splash_settings.use_redirect_url }}

{% else %}
    Skip    splash_settings.use_redirect_url is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/welcome_message{% if splash_settings.welcome_message is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[welcomeMessage]   {{ splash_settings.welcome_message }}

{% else %}
    Skip    splash_settings.welcome_message is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/theme_id{% if splash_settings.theme_id is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[themeId]   {{ splash_settings.theme_id }}

{% else %}
    Skip    splash_settings.theme_id is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/splash_logo{% if splash_settings.splash_logo is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.splash_logo }}
    ${validated}=    Validate Subset     ${splash_settings}[splashLogo]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.splash_logo is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/splash_image{% if splash_settings.splash_image is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.splash_image }}
    ${validated}=    Validate Subset     ${splash_settings}[splashImage]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.splash_image is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/splash_prepaid_front{% if splash_settings.splash_prepaid_front is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.splash_prepaid_front }}
    ${validated}=    Validate Subset     ${splash_settings}[splashPrepaidFront]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.splash_prepaid_front is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/guest_sponsorship{% if splash_settings.guest_sponsorship is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.guest_sponsorship }}
    ${validated}=    Validate Subset     ${splash_settings}[guestSponsorship]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.guest_sponsorship is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/block_all_traffic_before_sign_on{% if splash_settings.block_all_traffic_before_sign_on is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[blockAllTrafficBeforeSignOn]   {{ splash_settings.block_all_traffic_before_sign_on }}

{% else %}
    Skip    splash_settings.block_all_traffic_before_sign_on is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/controller_disconnection_behavior{% if splash_settings.controller_disconnection_behavior is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[controllerDisconnectionBehavior]   {{ splash_settings.controller_disconnection_behavior }}

{% else %}
    Skip    splash_settings.controller_disconnection_behavior is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/allow_simultaneous_logins{% if splash_settings.allow_simultaneous_logins is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    Should Be Equal As Strings   ${splash_settings}[allowSimultaneousLogins]   {{ splash_settings.allow_simultaneous_logins }}

{% else %}
    Skip    splash_settings.allow_simultaneous_logins is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/billing{% if splash_settings.billing is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.billing }}
    ${validated}=    Validate Subset     ${splash_settings}[billing]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.billing is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/sentry_enrollment{% if splash_settings.sentry_enrollment is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.sentry_enrollment }}
    ${validated}=    Validate Subset     ${splash_settings}[sentryEnrollment]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.sentry_enrollment is not defined
{% endif %}
Verify {{ organization.name }}/networks/{{ network.name }}/wireless.ssids/{{ wireless_ssid.name }}/splash_settings/self_registration{% if splash_settings.self_registration is defined %}
    [Setup]   Get Meraki Data   /networks/{networkId}/wireless/ssids/{number}/splash/settings   ['{{ organization.name }}', '{{ network.name }}', '{{ wireless_ssid.name }}']   splash_settings
    ${evaluated}=    Evaluate    {{ splash_settings.self_registration }}
    ${validated}=    Validate Subset     ${splash_settings}[selfRegistration]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    splash_settings.self_registration is not defined
{% endif %}


{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
