# @summary Manage OpenSM
#
# @example Manage OpenSM on two specific ports
#   class { 'mofed::opensm':
#     ports => ['mlx4_1 1', 'mlx4_1 2'],
#   }
#
# @param ensure
#   State of opensm.  `present` will run opensm.
#   `disabled` will install and configure opensm but disable services.
#   `absent` will remove opensm.
# @param ports
#   Ports used by opensm
# @param sweep
#   Value passsed to opensm `-s` argument.
#
class mofed::opensm (
  Enum['present', 'absent', 'disabled'] $ensure = 'present',
  Array $ports = [],
  Integer $sweep = 10,
) {

  include mofed

  case $ensure {
    'present': {
      $package_ensure = 'present'
      $file_ensure    = 'file'
      $service_ensure = 'running'
      $service_enable = true
    }
    'absent': {
      $package_ensure = 'absent'
      $file_ensure    = 'absent'
      $service_ensure = 'stopped'
      $service_enable = false
    }
    'disabled': {
      $package_ensure = 'present'
      $file_ensure    = 'file'
      $service_ensure = 'stopped'
      $service_enable = false
    }
    default: {
      # Do nothing
    }
  }

  package { 'opensm':
    ensure  => $package_ensure,
    require => Class['mofed::repo'],
  }

  # Template uses:
  # - $sweep
  # - $ports
  file { '/etc/sysconfig/opensm':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mofed/opensm/opensm.sysconfig.erb'),
    require => Package['opensm'],
  }

  # opensmd can not be limited to specific ports
  # so only run if ports are not defined
  if empty($ports) {
    service { 'opensmd':
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File['/etc/sysconfig/opensm'],
    }
  } else {
    service { 'opensmd':
      ensure     => 'stopped',
      enable     => false,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['opensm'],
    }

    if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
      systemd::unit_file { 'opensmd@.service':
        ensure => $file_ensure,
        source => 'puppet:///modules/mofed/opensm/opensmd@.service',
      }

      $ports.each |Integer $index, String $port| {
        $i = $index + 1
        service { "opensmd@${i}":
          ensure     => $service_ensure,
          enable     => $service_enable,
          hasstatus  => true,
          hasrestart => true,
          require    => Exec['systemctl-daemon-reload'],
          subscribe  => [
            File['/etc/sysconfig/opensm'],
            Systemd::Unit_file['opensmd@.service']
          ]
        }
      }
    }
  }

}
