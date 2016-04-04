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

  $sssd_package_name       = $sssd::params::sssd_package_name,
  $service_name            = $sssd::params::service_name,
  $config                  = $sssd::params::config,
  $mkhomedir               = $sssd::params::mkhomedir,
  $enable_mkhomedir_cmd    = $sssd::params::enable_mkhomedir_cmd,
  $disable_mkhomedir_cmd   = $sssd::params::disable_mkhomedir_cmd,
  $pam_mkhomedir_check     = $sssd::params::pam_mkhomedir_check,
  $manage_idmap            = $sssd::params::manage_idmap,
  $idmap_package_name      = $sssd::params::idmap_package_name,
  $use_legacy_packages     = $sssd::params::use_legacy_packages,
  $legacy_package_names    = $sssd::params::legacy_package_names,
  $manage_authconfig       = $sssd::params::manage_authconfig,
  $authconfig_package_name = $sssd::params::authconfig_package_name,
  $include_default_config  = $sssd::params::include_default_config,

) inherits sssd::params {

  validate_string(
    $sssd_package_name,
    $service_name,
    $enable_mkhomedir_cmd,
    $disable_mkhomedir_cmd,
    $pam_mkhomedir_check,
    $idmap_package_name,
    $authconfig_package_name
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
    $manage_authconfig
  )
  validate_hash($config)

  class { 'sssd::install': } ->
  class { 'sssd::config': } ~>
  class { 'sssd::service': } ->
  Class['sssd']
}
