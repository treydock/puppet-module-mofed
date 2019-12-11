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
#   Gateway address.
# @param ensure
#   Interface ensure value.
# @param enable
#   Boolean of whether to enable the interface at boot.
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
  Stdlib::Compat::Ip_address $ipaddr,
  Stdlib::Compat::Ip_address $netmask,
  Optional[Stdlib::Compat::Ip_address] $gateway = undef,
  Enum['present', 'absent'] $ensure           = 'present',
  Boolean $enable = true,
  Enum['yes', 'no'] $connected_mode           = 'yes',
  Optional[Integer] $mtu = undef,
  Boolean $bonding = false,
  Array[String] $bonding_slaves = [],
  String $bonding_opts = 'mode=active-backup miimon=100',
) {

  include mofed

  $onboot = $enable ? {
    true    => 'yes',
    false   => 'no',
    default => $enable,
  }

  $options_extra_redhat = {
    'CONNECTED_MODE' => $connected_mode,
  }

  if $bonding {
    if empty($bonding_slaves) {
      fail("No slave interfaces given for bonding interface ${name}")
    }

    # Setup interfaces for the slaves
    $bonding_slaves.each |String $ifname| {
      network::interface { $ifname:
        ensure               => $ensure,
        enable               => $enable,
        onboot               => $onboot,
        type                 => 'InfiniBand',
        master               => $name,
        slave                => 'yes',
        nm_controlled        => 'no',
        mtu                  => $mtu,
        options_extra_redhat => $options_extra_redhat,
      }
    }

    # Setup the bonding interface
    network::interface { $name:
      ensure         => $ensure,
      enable         => $enable,
      onboot         => $onboot,
      type           => 'Bond',
      ipaddress      => $ipaddr,
      netmask        => $netmask,
      gateway        => $gateway,
      bonding_master => 'yes',
      bonding_opts   => $bonding_opts,
      nm_controlled  => 'no',
      mtu            => $mtu,
    }
  } else {
    network::interface { $name:
      ensure               => $ensure,
      enable               => $enable,
      onboot               => $onboot,
      type                 => 'InfiniBand',
      ipaddress            => $ipaddr,
      netmask              => $netmask,
      gateway              => $gateway,
      nm_controlled        => 'no',
      mtu                  => $mtu,
      options_extra_redhat => $options_extra_redhat,
    }
  }

}
