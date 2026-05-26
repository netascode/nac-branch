
*** Settings ***
Library    String
Library    ../myutils.py

*** Test Cases ***
{% for domain in meraki.domains | default([], true) %}
{% for organization in domain.organizations | default([], true) %}

{% set login_security = organization.login_security | default({}, true) %}
Verify {{ organization.name }}/login_security/enforce_password_expiration{% if login_security.enforce_password_expiration is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforcePasswordExpiration]   {{ login_security.enforce_password_expiration }}

{% else %}
    Skip    login_security.enforce_password_expiration is not defined
{% endif %}
Verify {{ organization.name }}/login_security/password_expiration_days{% if login_security.password_expiration_days is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[passwordExpirationDays]   {{ login_security.password_expiration_days }}

{% else %}
    Skip    login_security.password_expiration_days is not defined
{% endif %}
Verify {{ organization.name }}/login_security/enforce_different_passwords{% if login_security.enforce_different_passwords is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforceDifferentPasswords]   {{ login_security.enforce_different_passwords }}

{% else %}
    Skip    login_security.enforce_different_passwords is not defined
{% endif %}
Verify {{ organization.name }}/login_security/num_different_passwords{% if login_security.num_different_passwords is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[numDifferentPasswords]   {{ login_security.num_different_passwords }}

{% else %}
    Skip    login_security.num_different_passwords is not defined
{% endif %}
Verify {{ organization.name }}/login_security/enforce_strong_passwords{% if login_security.enforce_strong_passwords is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforceStrongPasswords]   {{ login_security.enforce_strong_passwords }}

{% else %}
    Skip    login_security.enforce_strong_passwords is not defined
{% endif %}
Verify {{ organization.name }}/login_security/enforce_account_lockout{% if login_security.enforce_account_lockout is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforceAccountLockout]   {{ login_security.enforce_account_lockout }}

{% else %}
    Skip    login_security.enforce_account_lockout is not defined
{% endif %}
Verify {{ organization.name }}/login_security/account_lockout_attempts{% if login_security.account_lockout_attempts is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[accountLockoutAttempts]   {{ login_security.account_lockout_attempts }}

{% else %}
    Skip    login_security.account_lockout_attempts is not defined
{% endif %}
Verify {{ organization.name }}/login_security/enforce_idle_timeout{% if login_security.enforce_idle_timeout is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforceIdleTimeout]   {{ login_security.enforce_idle_timeout }}

{% else %}
    Skip    login_security.enforce_idle_timeout is not defined
{% endif %}
Verify {{ organization.name }}/login_security/idle_timeout_minutes{% if login_security.idle_timeout_minutes is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[idleTimeoutMinutes]   {{ login_security.idle_timeout_minutes }}

{% else %}
    Skip    login_security.idle_timeout_minutes is not defined
{% endif %}
Verify {{ organization.name }}/login_security/enforce_two_factor_auth{% if login_security.enforce_two_factor_auth is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforceTwoFactorAuth]   {{ login_security.enforce_two_factor_auth }}

{% else %}
    Skip    login_security.enforce_two_factor_auth is not defined
{% endif %}
Verify {{ organization.name }}/login_security/enforce_login_ip_ranges{% if login_security.enforce_login_ip_ranges is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    Should Be Equal As Strings   ${login_security}[enforceLoginIpRanges]   {{ login_security.enforce_login_ip_ranges }}

{% else %}
    Skip    login_security.enforce_login_ip_ranges is not defined
{% endif %}
Verify {{ organization.name }}/login_security/login_ip_ranges{% if login_security.login_ip_ranges is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    ${evaluated}=    Evaluate    {{ login_security.login_ip_ranges }}
    ${validated}=    Validate Subset     ${login_security}[loginIpRanges]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    login_security.login_ip_ranges is not defined
{% endif %}
Verify {{ organization.name }}/login_security/api_authentication{% if login_security.api_authentication is defined %}
    [Setup]   Get Meraki Data   /organizations/{organizationId}/loginSecurity   ['{{ organization.name }}']   login_security
    ${evaluated}=    Evaluate    {{ login_security.api_authentication }}
    ${validated}=    Validate Subset     ${login_security}[apiAuthentication][ipRestrictionsForKeys]    ${evaluated}
    Should Be True   ${validated}

{% else %}
    Skip    login_security.api_authentication is not defined
{% endif %}


{% endfor %}
{% endfor %}
