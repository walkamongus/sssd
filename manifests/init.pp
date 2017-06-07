# == Class: sssd
#
# Full description of class sssd here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
# [*include_default_config*]
#   Includ default configuration for 'sssd.conf'. Defaults to true.
#
class sssd (

  $package_name,
  $package_ensure,
  $service_name,
  $config_file,
  $default_config,
  $config,
  $mkhomedir,
  $pam_mkhomedir_method,
  $enable_mkhomedir_cmd,
  $disable_mkhomedir_cmd,
  $pam_mkhomedir_file_path,
  $pam_mkhomedir_check,
  $pam_use_sssd_cmd,
  $pam_use_sssd_check,
  $cache_path,
  $clear_cache,
  $manage_idmap,
  $idmap_package_name,
  $use_legacy_packages,
  $legacy_package_names,
  $manage_authconfig,
  $authconfig_package_name,
  $include_default_config,

) {

  validate_string(
    $package_name,
    $service_name,
    $enable_mkhomedir_cmd,
    $disable_mkhomedir_cmd,
    $pam_mkhomedir_check,
    $pam_mkhomedir_method,
    $idmap_package_name,
    $authconfig_package_name,
    $pam_mkhomedir_file_path,
    $pam_use_sssd_cmd,
    $pam_use_sssd_check,
  )
  validate_re(
    $mkhomedir,
    [ '^disabled$', '^enabled$' ],
    'The mkhomedir parameter value should be set to "disabled" or "enabled"'
  )
  validate_array($legacy_package_names)
  validate_bool(
    $use_legacy_packages,
    $manage_idmap,
    $manage_authconfig,
    $clear_cache
  )
  validate_hash($config)

  class { '::sssd::install': }
  -> class { '::sssd::config': }
  ~> class { '::sssd::service': }
  -> Class['::sssd']
}
