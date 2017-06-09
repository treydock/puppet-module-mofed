# See README.md for more details.
class mofed (
  $manage_repo                  = true,
  $repo_baseurl                 = undef,
  $repo_gpgkey                  = undef,
  $manage_packages              = true,
  $package_ensure               = 'present',
  $package_name                 = $mofed::params::package_name,
  $extra_packages               = undef,
  $manage_service               = true,
  $restart_service              = false,
  $openibd_service_name         = $mofed::params::openibd_service_name,
  $openibd_service_ensure       = 'running',
  $openibd_service_enable       = true,
  $openibd_service_hasstatus    = $mofed::params::openibd_service_hasstatus,
  $openibd_service_hasrestart   = $mofed::params::openibd_service_hasrestart,
  $manage_config                = true,
  $openib_config_path           = $mofed::params::openib_config_path,
  $openib_shellvars             = {},
  $interfaces                   = {}
) inherits mofed::params {

  validate_bool(
    $manage_repo,
    $manage_packages,
    $manage_config,
    $manage_service,
    $restart_service
  )

  if $mofed::restart_service {
    $openib_shellvar_notify = Service['openibd']
  } else {
    $openib_shellvar_notify = undef
  }

  include mofed::repo
  include mofed::install
  include mofed::config
  include mofed::service

  anchor { 'mofed::start': }
  -> Class['mofed::repo']
  -> Class['mofed::install']
  -> Class['mofed::config']
  -> Class['mofed::service']
  -> anchor { 'mofed::end': }

  create_resources('mofed::interface', $interfaces)

}
