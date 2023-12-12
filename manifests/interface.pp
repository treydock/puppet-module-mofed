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
#   IP address, required when ensure=present
# @param netmask
#   Netmask address, required when ensure=present
# @param gateway
#   Gateway address.
# @param ensure
#   Interface ensure value.
# @param enable
#   Boolean of whether to enable the interface at boot.
# @param nm_controlled
#   Value for nm_controlled on interface
# @param connected_mode
#   The value for setting interface to connected mode.
# @param mtu
#   The MTU of the interface.
# @param bonding
#   If this interface is a bonding interface
# @param bonding_slaves
#   Array of interfaces that should be enslaved in the bonding interface
# @param bonding_opts
#   The bonding options to use for this bonding interface
#
define mofed::interface(
  Enum['present', 'absent'] $ensure           = 'present',
  Optional[Stdlib::Compat::Ip_address] $ipaddr = undef,
  Optional[Stdlib::Compat::Ip_address] $netmask = undef ,
  Optional[Stdlib::Compat::Ip_address] $gateway = undef,
  Boolean $enable = true,
  Optional[Variant[Boolean, Enum['yes','no']]] $nm_controlled = undef,
  Enum['yes', 'no'] $connected_mode           = 'yes',
  Optional[Integer] $mtu = undef,
  Boolean $bonding = false,
  Array[String] $bonding_slaves = [],
  String $bonding_opts = 'mode=active-backup miimon=100',
) {

  if $ensure == 'present' {
    if ! $ipaddr {
      fail('ipaddr is required with ensure=present')
    }
    if ! $netmask {
      fail('netmask is required with ensure=present')
    }
  }

  include mofed

  $onboot = $enable ? {
    true    => 'yes',
    false   => 'no',
    default => $enable,
  }

  $options_extra_redhat = {
    'CONNECTED_MODE' => $connected_mode,
  }

  if $mofed::osfamily == 'RedHat' and versioncmp($mofed::osmajor, '8') >= 0 {
    $_nm_controlled = pick($nm_controlled, false)
  } else {
    $_nm_controlled = pick($nm_controlled, 'no')
  }

  if $bonding {
    if empty($bonding_slaves) {
      fail("No slave interfaces given for bonding interface ${name}")
    }

    # Setup interfaces for the slaves
    $bonding_slaves.each |String $ifname| {
      network_config { $ifname:
        ensure               => $ensure,
        onboot               => $onboot,
        type                 => 'InfiniBand',
        master               => $name,
        slave                => 'yes',
        nm_controlled        => $_nm_controlled,
        mtu                  => $mtu,
        options_extra_redhat => $options_extra_redhat,
      }
    }

    # Setup the bonding interface
    network_config { $name:
      ensure         => $ensure,
      onboot         => $onboot,
      type           => 'Bond',
      ipaddress      => $ipaddr,
      netmask        => $netmask,
      gateway        => $gateway,
      bonding_master => 'yes',
      bonding_opts   => $bonding_opts,
      nm_controlled  => $_nm_controlled,
      mtu            => $mtu,
    }
  } else {
    network_config { $name:
      ensure               => $ensure,
      onboot               => $onboot,
      type                 => 'InfiniBand',
      ipaddress            => $ipaddr,
      netmask              => $netmask,
      gateway              => $gateway,
      nm_controlled        => $_nm_controlled,
      mtu                  => $mtu,
      options_extra_redhat => $options_extra_redhat,
    }
  }

}
