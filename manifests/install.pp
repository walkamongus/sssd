# == Class sssd::install
#
class sssd::install {

  package { $sssd::sssd_package_name:
    ensure => present,
  }

  package { $sssd::sssd_plugin_packages:
    ensure => present,
  }

}
