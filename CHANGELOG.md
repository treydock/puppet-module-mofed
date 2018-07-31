# treydock-mofed changelog

Release notes for the treydock-mofed module.

## [1.4.2](https://github.com/treydock/puppet-module-mofed/tree/1.4.2) (2018-07-31)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.4.1...1.4.2)

**Fixed bugs:**

- Fix infiniband\_hca\_port\_guids when IB stack is not functional [\#8](https://github.com/treydock/puppet-module-mofed/pull/8) ([treydock](https://github.com/treydock))

## [1.4.1](https://github.com/treydock/puppet-module-mofed/tree/1.4.1) (2018-07-31)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.4.0...1.4.1)

**Fixed bugs:**

- Fix facts to not produce 'unexpected return' errors [\#6](https://github.com/treydock/puppet-module-mofed/pull/6) ([treydock](https://github.com/treydock))

**Merged pull requests:**

- Document with puppet-strings [\#7](https://github.com/treydock/puppet-module-mofed/pull/7) ([treydock](https://github.com/treydock))

## [1.4.0](https://github.com/treydock/puppet-module-mofed/tree/1.4.0) (2018-07-18)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.3.0...1.4.0)

**Implemented enhancements:**

- Add infiniband\_hcas fact and infiniband\_hca\_port\_guids fact [\#5](https://github.com/treydock/puppet-module-mofed/pull/5) ([treydock](https://github.com/treydock))

## [1.3.0](https://github.com/treydock/puppet-module-mofed/tree/1.3.0) (2018-05-18)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.2.0...1.3.0)

**Implemented enhancements:**

- Add mellanox\_ofed\_version fact [\#3](https://github.com/treydock/puppet-module-mofed/pull/3) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Fix has\_mellanox\_infiniband fact to not throw error without lspci present [\#4](https://github.com/treydock/puppet-module-mofed/pull/4) ([treydock](https://github.com/treydock))

## [1.2.0](https://github.com/treydock/puppet-module-mofed/tree/1.2.0) (2017-11-12)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.1.0...1.2.0)

**Merged pull requests:**

- Use data types for all parameters [\#2](https://github.com/treydock/puppet-module-mofed/pull/2) ([treydock](https://github.com/treydock))

## [1.1.0](https://github.com/treydock/puppet-module-mofed/tree/1.1.0) (2017-11-02)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.0.0...1.1.0)

**Implemented enhancements:**

- Support hiera merging extra\_packages [\#1](https://github.com/treydock/puppet-module-mofed/pull/1) ([treydock](https://github.com/treydock))

## [1.0.0](https://github.com/treydock/puppet-module-mofed/tree/1.0.0) (2017-10-26)
[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/0.0.1...1.0.0)

- Replace validate functions with data types
- Drop Puppet 3 support
- Allow systemd dependency of 1.x

## [0.0.1](https://github.com/treydock/puppet-module-mofed/tree/0.0.1) (2017-10-26)

- Initial release
