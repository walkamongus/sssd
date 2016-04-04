# == Class sssd::params
#
# This class is meant to be called from sssd
# It sets variables according to platform
#
class sssd::params {

  $include_default_config = true

  case $::osfamily {
    'RedHat': {
      $sssd_package_name       = 'sssd'
      $service_name            = 'sssd'
      $config_file             = '/etc/sssd/sssd.conf'
      $config                  = {}
      $default_config          = {
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
      $mkhomedir               = 'disabled'
      $enable_mkhomedir_cmd    = '/usr/sbin/authconfig --enablemkhomedir --update'
      $disable_mkhomedir_cmd   = '/usr/sbin/authconfig --disablemkhomedir --update'
      $pam_mkhomedir_check     = '/bin/grep -E \'^USEMKHOMEDIR=yes$\' /etc/sysconfig/authconfig'
      $manage_idmap            = true
      $idmap_package_name      = 'libsss_idmap'
      $manage_authconfig       = true
      $authconfig_package_name = 'authconfig'
      $use_legacy_packages     = false
      $legacy_package_names    = [
        'libsss_sudo',
        'libsss_autofs',
      ]
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
