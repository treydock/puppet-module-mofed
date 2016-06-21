# See README.md for more details.
class mofed (
  $repo_baseurl                 = undef,
  $repo_gpgkey                  = undef,
  $package_ensure               = 'present',
  $package_name                 = $mofed::params::package_name,
  $extra_packages               = undef,
  $openibd_service_name         = $mofed::params::openibd_service_name,
  $openibd_service_ensure       = 'running',
  $openibd_service_enable       = true,
  $openibd_service_hasstatus    = $mofed::params::openibd_service_hasstatus,
  $openibd_service_hasrestart   = $mofed::params::openibd_service_hasrestart,
  $openib_config_path           = $mofed::params::openib_config_path,
  $openib_shellvars             = {},
) inherits mofed::params {

  include mofed::repo
  include mofed::install
  include mofed::config
  include mofed::service

  anchor { 'mofed::start': }->
  Class['mofed::repo']->
  Class['mofed::install']->
  Class['mofed::config']~>
  Class['mofed::service']->
  anchor { 'mofed::end': }

}
