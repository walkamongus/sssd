# == Class sssd::params
#
# This class is meant to be called from sssd
# It sets variables according to platform
#
class sssd::params {
  case $::osfamily {
    'RedHat': {
      $package_name = 'sssd'
      $service_name = 'sssd'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
