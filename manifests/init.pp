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

  String $package_name,
  String $package_ensure,
  String $service_name,
  Variant[Enum['running','stopped'], Boolean] $service_ensure,
  Stdlib::Absolutepath $config_file,
  Hash $config,
  Boolean $mkhomedir,
  Enum['pam-auth-update', 'authconfig'] $pam_mkhomedir_method,
  Variant[Stdlib::Absolutepath, Undef] $pam_mkhomedir_file_path,
  Stdlib::Absolutepath $cache_path,
  Boolean $clear_cache,
  Hash $required_packages,

) {

  class { '::sssd::install': }
  -> class { '::sssd::config': }
  ~> class { '::sssd::service': }
  -> Class['::sssd']
}
