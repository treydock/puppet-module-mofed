# See README.md for more details.
class mofed (
  Boolean $manage_repo                = true,
  $repo_baseurl                       = undef,
  $repo_gpgkey                        = undef,
  Boolean $manage_packages            = true,
  $package_ensure                     = 'present',
  $package_name                       = $mofed::params::package_name,
  $extra_packages                     = undef,
  Boolean $extra_packages_hiera_merge = false,
  Boolean $manage_service             = true,
  Boolean $restart_service            = false,
  $openibd_service_name               = $mofed::params::openibd_service_name,
  $openibd_service_ensure             = 'running',
  $openibd_service_enable             = true,
  $openibd_service_hasstatus          = $mofed::params::openibd_service_hasstatus,
  $openibd_service_hasrestart         = $mofed::params::openibd_service_hasrestart,
  Boolean $manage_config              = true,
  $openib_config_path                 = $mofed::params::openib_config_path,
  $openib_shellvars                   = {},
  $interfaces                         = {}
) inherits mofed::params {

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
