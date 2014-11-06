# == Class sssd::install
#
class sssd::install {

  package { $sssd::sssd_package_name:
    ensure => present,
  }

  package { $sssd::idmap_package_name:
    ensure => present,
  }

  if $sssd::use_legacy_packages {
    package { $sssd::legacy_package_names:
      ensure => present,
    }
  }

}
