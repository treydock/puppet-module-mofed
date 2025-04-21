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
define mofed::interface (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Stdlib::IP::Address] $ipaddr = undef,
  Optional[Stdlib::IP::Address] $netmask = undef ,
  Optional[Stdlib::IP::Address] $gateway = undef,
  Boolean $enable = true,
  Optional[Enum['yes','no']] $nm_controlled = undef,
  Enum['yes', 'no'] $connected_mode = 'yes',
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

  if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '7') == 0 {
    $_nm_controlled = pick($nm_controlled, 'no')
  } else {
    $_nm_controlled = $nm_controlled
  }

  if $bonding {
    if empty($bonding_slaves) {
      fail("No slave interfaces given for bonding interface ${name}")
    }

    # Setup interfaces for the slaves
    $bonding_slaves.each |String $ifname| {
      network_config { $ifname:
        ensure  => $ensure,
        onboot  => $enable,
        mtu     => $mtu,
        method  => 'static',
        hotplug => false,
        options => {
          'TYPE'           => 'Infiniband',
          'MASTER'         => $name,
          'SLAVE'          => 'yes',
          'CONNECTED_MODE' => $connected_mode,
          'NM_CONTROLLED'  => $_nm_controlled,
        }.filter |$k, $v| { $v =~ NotUndef },
      }
    }

    # Setup the bonding interface
    network_config { $name:
      ensure    => $ensure,
      onboot    => $enable,
      ipaddress => $ipaddr,
      netmask   => $netmask,
      mtu       => $mtu,
      method    => 'static',
      hotplug   => false,
      options   => {
        'TYPE'           => 'Bond',
        'BONDING_MASTER' => 'yes',
        'BONDING_OPTS'   => $bonding_opts,
        'GATEWAY'        => $gateway,
        'CONNECTED_MODE' => $connected_mode,
        'NM_CONTROLLED'  => $_nm_controlled,
      }.filter |$k, $v| { $v =~ NotUndef },
    }
  } else {
    network_config { $name:
      ensure    => $ensure,
      onboot    => $enable,
      ipaddress => $ipaddr,
      netmask   => $netmask,
      mtu       => $mtu,
      method    => 'static',
      hotplug   => false,
      options   => {
        'TYPE'           => 'Infiniband',
        'GATEWAY'        => $gateway,
        'CONNECTED_MODE' => $connected_mode,
        'NM_CONTROLLED'  => $_nm_controlled,
      }.filter |$k, $v| { $v =~ NotUndef },
    }
  }
}
