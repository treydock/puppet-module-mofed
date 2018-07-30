# @summary Manage IPoIB interface
#
# @example Add IPoIB interface
#   mofed::interface { 'ib0':
#     ensure         => 'present',
#     ipaddr         => '10.0.0.1',
#     netmask        => '255.255.0.0',
#     connected_mode => 'no',
#   }
#
# @param ipaddr
#   Required IP address.
# @param netmask
#   Required netmask address.
# @param gateway
#   Gateway address, `UNSET` will leave the value undefined.
# @param ensure
#   Interface ensure value.
# @param enable
#   Boolean of whether to enable the interface at boot.
# @param connected_mode
#   The value for setting interface to connected mode.
# @param mtu
#   The MTU of the interface, `UNSET` will leave the value undefined.
#
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
