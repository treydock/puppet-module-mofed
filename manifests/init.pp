# See README.md for more details.
class mofed (
  Boolean $manage_repo                      = true,
  Optional[String] $repo_baseurl            = undef,
  Optional[String] $repo_gpgkey             = undef,
  Boolean $manage_packages                  = true,
  String $package_ensure                    = 'present',
  String $package_name                      = $mofed::params::package_name,
  Optional[Array] $extra_packages           = undef,
  Boolean $extra_packages_hiera_merge       = false,
  Boolean $manage_service                   = true,
  Boolean $restart_service                  = false,
  String $openibd_service_name              = $mofed::params::openibd_service_name,
  String $openibd_service_ensure            = 'running',
  Boolean $openibd_service_enable           = true,
  Boolean $openibd_service_hasstatus        = $mofed::params::openibd_service_hasstatus,
  Boolean $openibd_service_hasrestart       = $mofed::params::openibd_service_hasrestart,
  Boolean $manage_config                    = true,
  Stdlib::Absolutepath $openib_config_path  = $mofed::params::openib_config_path,
  Hash $openib_shellvars                    = {},
  Hash $interfaces                          = {}
) inherits mofed::params {

  if $restart_service {
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
