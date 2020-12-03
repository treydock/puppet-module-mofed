# puppet-module-mofed

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/mofed.svg)](https://forge.puppetlabs.com/treydock/mofed)
[![CI Status](https://github.com/treydock/puppet-module-mofed/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-mofed/actions?query=workflow%3ACI)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
    * [Facts](#facts)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

The MOFED Puppet module manages Mellanox OFED for Linux.

## Usage

### mofed

Install and configure MOFED from site specific yum repo server.

    class { 'mofed':
      repo_baseurl => 'http://example.com/mlnx/$releasever/3.4-2.0.0.0-rhel7.3/'
      repo_gpgkey  => 'http://example.com/mlnx/$releasever/3.4-2.0.0.0-rhel7.3/RPM-GPG-KEY-Mellanox',
    }

### mofed::interface

Add IPoIB interface

    mofed::interface { 'ib0':
      ensure         => 'present',
      ipaddr         => '10.0.0.1',
      netmask        => '255.255.0.0',
      connected_mode => 'no',
    }

The same interface can be defined in Hiera if the mofed class is included

    mofed::interfaces:
      ib0:
        ensure: 'present'
        ipaddr: '10.0.0.1'
        netmask: '255.255.0.0'
        connected_mode: 'no'    

### mofed::opensm

Add opensm that is set for 2 ports.

    class { 'mofed::opensm':
      ports => ['mlx4_1 1', 'mlx4_1 2'],
    }

### mofed::srp

Add srp for 2 ports.

    class { 'mofed::srp':
      ports => ['mlx4_1 1', 'mlx4_1 2'],
    }


## Reference

[http://treydock.github.io/puppet-module-mofed/](http://treydock.github.io/puppet-module-mofed/)

### Facts

#### has\_mellanox\_infiniband

This boolean fact will return `true` if the system has a Mellanox Infiniband card.

#### mellanox\_ofed\_version

Returns the Mellanox OFED version that is installed

#### infiniband\_hcas

Moved to [treydock/infiniband](https://forge.puppetlabs.com/treydock/infiniband) module

#### infiniband\_hca\_port\_guids

Moved to [treydock/infiniband](https://forge.puppetlabs.com/treydock/infiniband) module

## Limitations

This module has been tested on:

* RedHat 7 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

## Further Information

*
