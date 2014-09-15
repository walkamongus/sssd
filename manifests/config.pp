# == Class sssd::config
#
# This class is called from sssd
#
class sssd::config {

  $final_config = deep_merge($sssd::params::default_config, $sssd::config)

  file {'sssd_config_file':
    path    => $sssd::config_file,
    content => template('sssd/sssd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  case $sssd::mkhomedir {
    'enabled': {
      exec {'enable mkhomedir':
        command => $sssd::enable_mkhomedir_cmd,
        unless  => $sssd::pam_mkhomedir_check,
      }
    }
    'disabled': {
      exec {'disable mkhomedir':
        command => $sssd::disable_mkhomedir_cmd,
        onlyif  => $sssd::pam_mkhomedir_check,
      }
    }
    default: {
    }
  }

}
