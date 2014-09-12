# == Class: sssd
#
# Full description of class sssd here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class sssd (
  $package_name = $sssd::params::package_name,
  $service_name = $sssd::params::service_name,
) inherits sssd::params {

  # validate parameters here

  class { 'sssd::install': } ->
  class { 'sssd::config': } ~>
  class { 'sssd::service': } ->
  Class['sssd']
}
