# See README.md for more details.
class mofed::opensm (
  Enum['present', 'absent', 'disabled'] $ensure = 'present',
  Array $ports = [],
  Integer $sweep = 10,
) inherits mofed::params {

  include mofed

  case $ensure {
    'present': {
      $package_ensure = 'present'
    }
    'absent': {
      $package_ensure = 'absent'
    }
    default: {
      # Do nothing
    }
  }

  package { 'opensm':
    ensure  => 'present',
    require => Class['mofed::repo'],
  }

  # Template uses:
  # - $sweep
  # - $ports
  file { '/etc/sysconfig/opensm':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mofed/opensm/opensm.sysconfig.erb'),
    require => Package['opensm'],
  }

  if empty($ports) {
    service { 'opensmd':
      ensure     => 'running',
      enable     => true,
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
        source => 'puppet:///modules/mofed/opensm/opensmd@.service',
      }

      $ports.each |Integer $index, String $port| {
        $i = $index + 1
        service { "opensmd@${i}":
          ensure     => 'running',
          enable     => true,
          hasstatus  => true,
          hasrestart => true,
          require    => Systemd::Unit_file['opensmd@.service'],
          subscribe  => File['/etc/sysconfig/opensm'],
        }
      }
    }
  }

}
