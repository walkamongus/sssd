# == Class sssd::service
#
# This class is meant to be called from sssd
# It ensure the service is running
#
class sssd::service {

  service { $sssd::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
