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
  Stdlib::Absolutepath $config_file,
  Hash $config,
  Boolean $mkhomedir,
  Enum['file', 'authconfig'] $pam_mkhomedir_method,
  String $enable_mkhomedir_cmd,
  String $disable_mkhomedir_cmd,
  Variant[Stdlib::Absolutepath, Undef] $pam_mkhomedir_file_path,
  String $pam_mkhomedir_check,
  Variant[String, Undef] $pam_use_sssd_cmd,
  Variant[String, Undef] $pam_use_sssd_check,
  Stdlib::Absolutepath $cache_path,
  Boolean $clear_cache,
  Boolean $manage_idmap,
  String $idmap_package_name,
  Boolean $use_legacy_packages,
  Array $legacy_package_names,
  Boolean $manage_authconfig,
  String $authconfig_package_name,

) {

  class { '::sssd::install': }
  -> class { '::sssd::config': }
  ~> class { '::sssd::service': }
  -> Class['::sssd']
}
