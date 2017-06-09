# See README.md for more details.
class mofed::srp (
  Enum['present', 'absent', 'disabled'] $ensure = 'present',
) inherits mofed::params {

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

  package { 'srptools':
    ensure  => $package_ensure,
    require => Class['mofed::repo'],
  }

  file { '/etc/rsyslog.d/srp_daemon.conf':
    ensure  => 'absent',
    require => Package['srptools'],
  }

  rsyslog::snippet { '60_srp_daemon.conf':
    ensure  => $file_ensure,
    content => template('mofed/srp/srp_daemon.rsyslog.conf.erb'),
    require => Package['srptools'],
  }

  service { 'srpd':
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['srptools'],
  }

}
