# == Class sssd::config
#
# This class is called from sssd
#
class sssd::config (

  $include_default_config = $::sssd::include_default_config,
  $cache_flush_test = "test $(find ${sssd::cache_path} -size +2999M | wc -l) -gt 0",
) {

  if $include_default_config {
    $final_config = deep_merge($sssd::default_config, $sssd::config)
  } else {
    $final_config = $sssd::config
  }

  exec {'clear_cache':
    refreshonly => true,
    command     => "/bin/rm -f ${sssd::cache_path}",
    notify      => Service['sssd'],
  }

  exec {'cache_overflow':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => '/bin/true',
    onlyif  => $cache_flush_test,
    notify  => Exec['clear_cache'],
  }

  if $sssd::clear_cache {
    file {'sssd_config_file':
      path    => $sssd::config_file,
      content => template('sssd/sssd.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      notify  => Exec['clear_cache'],
    }
  } else {
    file {'sssd_config_file':
      path    => $sssd::config_file,
      content => template('sssd/sssd.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
    }
  }

  $pam_mkhomedir_file_ensure = $sssd::mkhomedir ? {
    'enabled'  => present,
    'disabled' => absent,
  }

  $pam_mkhomedir_exec_name = $sssd::mkhomedir ? {
    'enabled'  => 'enable',
    'disabled' => 'disable',
  }

  case $sssd::pam_mkhomedir_method {
    'file': {
      file { $sssd::pam_mkhomedir_file_path:
        ensure => $pam_mkhomedir_file_ensure,
        source => 'puppet:///modules/sssd/mkhomedir',
        before => Exec["${pam_mkhomedir_exec_name} mkhomedir"],
      }
    } 'authconfig': {
        exec { 'authconfig use sssd for authconfig':
          command => $sssd::pam_use_sssd_cmd,
          unless  => $sssd::pam_use_sssd_check,
        }
    } default: {
    }
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
