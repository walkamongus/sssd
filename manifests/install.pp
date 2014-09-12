# == Class sssd::install
#
class sssd::install {

  package { $sssd::sssd_package_name:
    ensure => present,
  }

  package { $sssd::sudo_package_name:
    ensure => present,
  }

  package { $sssd::autofs_package_name:
    ensure => present,
  }

  package { $sssd::ipa_package_name:
    ensure => present,
  }

}
