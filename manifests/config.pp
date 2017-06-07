# == Class sssd::config
#
# This class is called from sssd
#
class sssd::config {

  $cache_flush_test = "test $(find ${sssd::cache_path} -size +2999M | wc -l) -gt 0"

  if $sssd::clear_cache {
    $config_params = {
      'notify'  => 'Exec[clear_cache]',
    }
  } else {
    $config_params = {}
  }

  file {'sssd_config_file':
    ensure  => file,
    path    => $sssd::config_file,
    content => template('sssd/sssd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    *       => $config_params,
  }

  exec {'cache_overflow':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => '/bin/true',
    onlyif  => $cache_flush_test,
    notify  => Exec['clear_cache'],
  }

  exec {'clear_cache':
    refreshonly => true,
    command     => "/bin/rm -f ${sssd::cache_path}",
    notify      => Service['sssd'],
  }

  if $sssd::mkhomedir {
    $pam_mkhomedir_file_ensure = file
    $pam_mkhomedir_exec_name = 'enable'

    exec {'enable_mkhomedir':
      command => $sssd::enable_mkhomedir_cmd,
      unless  => $sssd::pam_mkhomedir_check,
    }
  } else {
    $pam_mkhomedir_file_ensure = absent
    $pam_mkhomedir_exec_name = 'disable'

    exec {'disable_mkhomedir':
      command => $sssd::disable_mkhomedir_cmd,
      onlyif  => $sssd::pam_mkhomedir_check,
    }
  }

  case $sssd::pam_mkhomedir_method {
    'file': {
      file { $sssd::pam_mkhomedir_file_path:
        ensure => $pam_mkhomedir_file_ensure,
        source => 'puppet:///modules/sssd/mkhomedir',
        before => Exec["${pam_mkhomedir_exec_name}_mkhomedir"],
      }
    }
    'authconfig': {
        exec { 'authconfig use sssd for authconfig':
          command => $sssd::pam_use_sssd_cmd,
          unless  => $sssd::pam_use_sssd_check,
        }
    }
    default: {}
  }

}
