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
      $sssd_package_ensure     = 'present'
      $sssd_cache_path         = '/var/lib/sss/db/*'
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
      $pam_mkhomedir_method    = 'authconfig'
      $enable_mkhomedir_cmd    = '/usr/sbin/authconfig --enablemkhomedir --update'
      $disable_mkhomedir_cmd   = '/usr/sbin/authconfig --disablemkhomedir --update'
      $pam_mkhomedir_file_path = ''
      $pam_mkhomedir_check     = '/bin/grep -E \'^USEMKHOMEDIR=yes$\' /etc/sysconfig/authconfig'
      $pam_use_sssd_cmd        = '/usr/sbin/authconfig --enablesssd --enablesssdauth --update'
      $pam_use_sssd_check      = '/bin/grep -E \'USESSSDAUTH=yes\' /etc/sysconfig/authconfig &&\
                                  /bin/grep -E \'USESSSD=yes\' /etc/sysconfig/authconfig'
      $sssd_clear_cache        = false
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
    'Debian': {
      $sssd_package_name       = 'sssd'
      $sssd_package_ensure     = 'present'
      $sssd_cache_path         = '/var/lib/sss/db/*'
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
      $pam_mkhomedir_method    = 'file'
      $enable_mkhomedir_cmd    = '/usr/sbin/pam-auth-update'
      $disable_mkhomedir_cmd   = '/usr/sbin/pam-auth-update'
      $pam_mkhomedir_file_path = '/usr/share/pam-configs/mkhomedir'
      $pam_mkhomedir_check     = "/bin/grep -E \'pam_mkhomedir.so\' /etc/pam.d/common-session"
      $pam_use_sssd_cmd        = ''
      $pam_use_sssd_check      = ''
      $sssd_clear_cache        = false
      $manage_idmap            = true
      $idmap_package_name      = 'libsss-idmap0'
      $manage_authconfig       = true
      $authconfig_package_name = 'libpam-runtime'
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
