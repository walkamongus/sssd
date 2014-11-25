# == Class sssd::install
#
class sssd::install {

  package { $sssd::sssd_package_name:
    ensure => present,
  }

  if $sssd::manage_idmap {
    package { $sssd::idmap_package_name:
      ensure => present,
    }
  }

  if $sssd::manage_authconfig {
    package { $sssd::authconfig_package_name:
      ensure => present,
    }
  }

  if $sssd::use_legacy_packages {
    package { $sssd::legacy_package_names:
      ensure => present,
    }
  }

}
