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

  $sssd_package_name     = $sssd::params::sssd_package_name,
  $sssd_plugin_packages  = $sssd::params::sssd_plugin_packages,
  $service_name          = $sssd::params::service_name,
  $config                = $sssd::params::config,
  $mkhomedir             = $sssd::params::mkhomedir,
  $enable_mkhomedir_cmd  = $sssd::params::enable_mkhomedir_cmd,
  $disable_mkhomedir_cmd = $sssd::params::disable_mkhomedir_cmd,
  $pam_mkhomedir_check   = $sssd::params::pam_mkhomedir_check,

) inherits sssd::params {

  validate_string(
    $sssd_package_name,
    $sudo_package_name,
    $autofs_package_name,
    $ipa_package_name,
    $service_name,
    $enable_mkhomedir_cmd,
    $disable_mkhomedir_cmd,
    $pam_mkhomedir_check
  )
  validate_re(
    $mkhomedir,
    [ '^disabled$', '^enabled$' ],
    'The mkhomedir parameter value should be set to "disabled" or "enabled"'
  )
  validate_hash($config)

  class { 'sssd::install': } ->
  class { 'sssd::config': } ~>
  class { 'sssd::service': } ->
  Class['sssd']
}
