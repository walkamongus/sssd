# == Class sssd::params
#
# This class is meant to be called from sssd
# It sets variables according to platform
#
class sssd::params {
  case $::osfamily {
    'RedHat': {
      $sssd_package_name   = 'sssd'
      $sudo_package_name   = 'libsss_sudo'
      $autofs_package_name = 'libsss_autofs'
      $ipa_package_name    = 'libsss_idmap'
      $service_name        = 'sssd'
      $config_file         = '/etc/sssd/sssd.conf'
      $config              = {}
      $default_config      = {
        'sssd'                  => {
          'config_file_version' => '2',
          'services'            => 'nss,pam',
          'domains'             => 'LDAP',
        },
        'nss'                 => {},
        'pam'                 => {},
        'domain/LDAP'         => {
          'id_provider'       => 'ldap',
          'cache_credentials' => true,
        },
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
