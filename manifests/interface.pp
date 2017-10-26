# == Define: mofed::interface
#
# See README.md for more details.
define mofed::interface(
  $ipaddr,
  $netmask,
  $gateway                                    = 'UNSET',
  Enum['present', 'absent'] $ensure           = 'present',
  Variant[Boolean, Enum['yes', 'no']] $enable = true,
  Enum['yes', 'no'] $connected_mode           = 'yes',
  $mtu                                        = 'UNSET'
) {

  include mofed

  $onboot = $enable ? {
    true    => 'yes',
    false   => 'no',
    default => $enable,
  }

  if $mofed::restart_service {
    $_notify = Service['openibd']
  } else {
    $_notify = undef
  }

  file { "/etc/sysconfig/network-scripts/ifcfg-${name}":
    ensure  => $ensure,
    content => template('mofed/ifcfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => $_notify,
  }

}
