# == Class sssd::params
#
# This class is meant to be called from sssd
# It sets variables according to platform
#
class sssd::params {
  case $::osfamily {
    'RedHat': {
      $package_name   = 'sssd'
      $service_name   = 'sssd'
      $config_file    = '/etc/sssd/sssd.conf'
      $config         = {}
      $default_config = {
        'sssd'                  => {
          'config_file_version' => '2',
          'services'            => 'nss,pam',
          'domains'             => 'LDAP',
        },
        'nss'                 => {},
        'pam'                 => {},
        'domain/LDAP'         => {
          'id_provider'       => 'ldap',
          'auth_provider'     => 'ldap',
          'ldap_schema'       => 'rfc2307',
          'ldap_uri'          => 'ldap://ldap.mydomain.org',
          'ldap_search_base'  => 'dc=mydomain,dc=org',
          'enumerate'         => 'false',
          'cache_credentials' => 'true',
        },
        'domain/AD'                     => {
          'id_provider'                 => 'ldap',
          'auth_provider'               => 'krb5',
          'chpass_provider'             => 'krb5',
          'ldap_uri'                    => 'ldap://your.ad.example.com',
          'ldap_search_base'            => 'dc=example,dc=com',
          'ldap_schema'                 => 'rfc2307bis',
          'ldap_sasl_mech'              => 'GSSAPI',
          'ldap_user_object_class'      => 'user',
          'ldap_group_object_class'     => 'group',
          'ldap_user_home_directory'    => 'unixHomeDirectory',
          'ldap_user_principal'         => 'userPrincipalName',
          'ldap_account_expire_policy'  => 'ad',
          'ldap_force_upper_case_realm' => 'true',
          'krb5_server'                 => 'your.ad.example.com',
          'krb5_realm'                  => 'EXAMPLE.COM',
        },
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
