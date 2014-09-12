# == Class sssd::config
#
# This class is called from sssd
#
class sssd::config {

  $final_config = merge($sssd::params::default_config, $sssd::config)

  file {'sssd_config_file':
    path    => $sssd::config_file,
    content => template('sssd/sssd.conf.erb'),
    mode    => '0644',
  }

}
