# @summary Manage SRP
#
# @example Manage SRP for specific ports
#   class { 'mofed::srp':
#    ports => ['mlx4_1 1', 'mlx4_1 2'],
#   }
#
# @param ensure
#   State of srp.  `present` will run opensm.
#   `disabled` will install and configure opensm but disable services.
#   `absent` will remove opensm.
# @param ports
#   Ports used by srp daemon.
# @param srp_daemon_config
#   Define lines in srp_daemon.conf
# @param ib_srp_options
#   Options passed to ib_srp kernel module
#
class mofed::srp (
  Enum['present', 'absent', 'disabled'] $ensure = 'present',
  Array $ports = [],
  Optional[Variant[String, Array]] $srp_daemon_config = undef,
  Optional[Hash[String, Variant[String,Integer], 1]] $ib_srp_options = undef,
) {
  include mofed

  case $ensure {
    'present': {
      $package_ensure = 'present'
      $file_ensure    = 'file'
      $srp_load       = 'yes'
      $unit_ensure    = 'present'
      $service_ensure = 'running'
      $service_enable = true
    }
    'absent': {
      $package_ensure = 'absent'
      $file_ensure    = 'absent'
      $srp_load       = 'no'
      $unit_ensure    = 'absent'
      $service_ensure = 'stopped'
      $service_enable = false
    }
    'disabled': {
      $package_ensure = 'present'
      $file_ensure    = 'file'
      $srp_load       = 'yes'
      $unit_ensure    = 'present'
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

  if $mofed::manage_config {
    shellvar { 'SRP_LOAD':
      ensure  => 'present',
      target  => $mofed::openib_config_path,
      value   => $srp_load,
      notify  => $mofed::openib_shellvar_notify,
      require => Class['mofed::install'],
    }
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

  # Template uses:
  # - $srp_daemon_config
  file { '/etc/srp_daemon.conf':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mofed/srp/srp_daemon.conf.erb'),
    require => Package['srptools'],
  }

  # Template uses:
  # - $ports
  file { '/etc/sysconfig/srpd':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mofed/srp/srpd.sysconfig.erb'),
    require => Package['srptools'],
  }

  # Template uses:
  # - $ib_srp_options
  if $ib_srp_options {
    file { '/etc/modprobe.d/ib_srp.conf':
      ensure  => $file_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('mofed/srp/ib_srp.conf.erb'),
      require => Package['srptools'],
    }
  } else {
    file { '/etc/modprobe.d/ib_srp.conf':
      ensure  => 'absent',
      require => Package['srptools'],
    }
  }

  # opensmd can not be limited to specific ports
  # so only run if ports are not defined
  if empty($ports) {
    service { 'srpd':
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
      #subscribe  => File[$mofed::openib_config_path],
      require    => Package['srptools'],
    }
  } else {
    service { 'srpd':
      ensure     => 'stopped',
      enable     => false,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['srptools'],
    }

    systemd::unit_file { 'srpd@.service':
      ensure => $unit_ensure,
      source => 'puppet:///modules/mofed/srp/srpd@.service',
    }

    $ports.each |Integer $index, String $port| {
      $i = $index + 1
      service { "srpd@${i}":
        ensure     => $service_ensure,
        enable     => $service_enable,
        hasstatus  => true,
        hasrestart => true,
        require    => [
          File['/etc/modprobe.d/ib_srp.conf'],
        ],
        subscribe  => [
          File['/etc/sysconfig/srpd'],
          File['/etc/srp_daemon.conf'],
          Systemd::Unit_file['srpd@.service'],
        ],
      }
    }
  }
}
