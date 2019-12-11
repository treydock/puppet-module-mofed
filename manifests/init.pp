# @summary Manage Mellanox OFED
#
# @example Basic usage using local yum repo for MOFED
#   class { 'mofed':
#     repo_baseurl => 'http://example.com/mlnx/$releasever/3.4-2.0.0.0-rhel7.3/'
#     repo_gpgkey  => 'http://example.com/mlnx/$releasever/3.4-2.0.0.0-rhel7.3/RPM-GPG-KEY-Mellanox',
#   }
#
# @param manage_repo
#   Boolean to set if MOFED repo should be managed
# @param repo_baseurl
#   The baseurl of the yumrepo resource
# @param repo_gpgkey
#   The gpgkey of the yumrepo resource
# @param manage_packages
#   Boolean to determine if packages should be managed
# @param package_ensure
#   The package ensure property
# @param package_name
#   The MOFED package name to install
# @param extra_packages
#   An array of additional packages to install
# @param extra_packages_hiera_merge
#   Boolean that sets if extra_packages should have values merged from hiera
# @param manage_service
#   Boolean that determines if the openibd service should be managed
# @param restart_service
#   Boolean that sets of openibd should be restarted
# @param openibd_service_name
#   Name of the openibd service
# @param openibd_service_ensure
#   openibd service ensure property
# @param openibd_service_enable
#   openibd service enable property
# @param openibd_service_hasstatus
#   openibd service hasstatus property
# @param openibd_service_hasrestart
#   openibd service hasrestart property
# @param manage_config
#   Boolean that sets if configs should be managed
# @param openib_config_path
#   Path to openib.conf
# @param openib_shellvars
#   Hash of shellvar resources
# @param interfaces
#   Hash of mofed::interface resources
#
class mofed (
  Boolean $manage_repo                      = true,
  Optional[String] $repo_baseurl            = undef,
  Optional[String] $repo_gpgkey             = undef,
  Boolean $manage_packages                  = true,
  String $package_ensure                    = 'present',
  String $package_name                      = 'mlnx-ofed-basic',
  Optional[Array] $extra_packages           = undef,
  Boolean $extra_packages_hiera_merge       = false,
  Boolean $manage_service                   = true,
  Boolean $restart_service                  = false,
  String $openibd_service_name              = 'openibd',
  String $openibd_service_ensure            = 'running',
  Boolean $openibd_service_enable           = true,
  Boolean $openibd_service_hasstatus        = true,
  Boolean $openibd_service_hasrestart       = true,
  Boolean $manage_config                    = true,
  Stdlib::Absolutepath $openib_config_path  = '/etc/infiniband/openib.conf',
  Hash $openib_shellvars                    = {},
  Hash $interfaces                          = {}
) {

  $osfamily = $facts.dig('os', 'family')
  $osmajor = $facts.dig('os', 'release', 'major')
  $supported = ['RedHat-6','RedHat-7','RedHat-8']
  $os = "${osfamily}-${osmajor}"
  if ! ($os in $supported) {
    fail("Unsupported OS: ${osfamily}, module ${module_name} only supports RedHat 6, 7, and 8")
  }

  if $restart_service {
    $openib_shellvar_notify = Service['openibd']
  } else {
    $openib_shellvar_notify = undef
  }

  contain mofed::repo
  contain mofed::install
  contain mofed::config
  contain mofed::service

  Class['mofed::repo']
  -> Class['mofed::install']
  -> Class['mofed::config']
  -> Class['mofed::service']

  create_resources('mofed::interface', $interfaces)

}
