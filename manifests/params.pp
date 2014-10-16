# == Class sssd::params
#
# This class is meant to be called from sssd
# It sets variables according to platform
#
class sssd::params {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        '6.6': {
          $sssd_plugin_packages = [
            'sssd-common',
            'libsss_idmap',
          ]
        }
        default: {
          $sssd_plugin_packages = [
            'libsss_sudo',
            'libsss_autofs',
            'libsss_idmap',
          ]
        }
      }
      $sssd_package_name   = 'sssd'
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
      $mkhomedir             = 'disabled'
      $enable_mkhomedir_cmd  = '/usr/sbin/authconfig --enablemkhomedir --update'
      $disable_mkhomedir_cmd = '/usr/sbin/authconfig --disablemkhomedir --update'
      $pam_mkhomedir_check   =  '/bin/grep -E \'^USEMKHOMEDIR=yes$\' /etc/sysconfig/authconfig'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
