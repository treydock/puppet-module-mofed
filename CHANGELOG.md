# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v4.0.0](https://github.com/treydock/puppet-module-mofed/tree/v4.0.0) (2024-10-07)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v3.1.0...v4.0.0)

### Changed

- Use puppet/network for network interface dependency [\#26](https://github.com/treydock/puppet-module-mofed/pull/26) ([treydock](https://github.com/treydock))
- Major updates - read description [\#25](https://github.com/treydock/puppet-module-mofed/pull/25) ([treydock](https://github.com/treydock))

## [v3.1.0](https://github.com/treydock/puppet-module-mofed/tree/v3.1.0) (2022-04-07)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v3.0.0...v3.1.0)

### Added

- Replace CentOS 8 with Rocky 8 - do not set NM\_CONTROLLED=no for EL8 by default [\#23](https://github.com/treydock/puppet-module-mofed/pull/23) ([treydock](https://github.com/treydock))

## [v3.0.0](https://github.com/treydock/puppet-module-mofed/tree/v3.0.0) (2021-05-19)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v2.3.1...v3.0.0)

### Changed

- Drop Puppet 5, add Puppet 7, drop EL6 [\#21](https://github.com/treydock/puppet-module-mofed/pull/21) ([treydock](https://github.com/treydock))

### Added

- Add repo\_priority parameter [\#22](https://github.com/treydock/puppet-module-mofed/pull/22) ([treydock](https://github.com/treydock))

## [v2.3.1](https://github.com/treydock/puppet-module-mofed/tree/v2.3.1) (2020-12-03)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v2.3.0...v2.3.1)

### Fixed

- Avoid invalid hash data warning [\#19](https://github.com/treydock/puppet-module-mofed/pull/19) ([treydock](https://github.com/treydock))

## [v2.3.0](https://github.com/treydock/puppet-module-mofed/tree/v2.3.0) (2020-12-02)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v2.2.0...v2.3.0)

### Added

- Allow repo GPG check to be disabled [\#17](https://github.com/treydock/puppet-module-mofed/pull/17) ([treydock](https://github.com/treydock))

## [v2.2.0](https://github.com/treydock/puppet-module-mofed/tree/v2.2.0) (2020-04-29)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v2.1.0...v2.2.0)

### Added

- Better support for interface ensure=absent [\#16](https://github.com/treydock/puppet-module-mofed/pull/16) ([treydock](https://github.com/treydock))

## [v2.1.0](https://github.com/treydock/puppet-module-mofed/tree/v2.1.0) (2020-04-03)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/v2.0.0...v2.1.0)

### Added

- Allow repo exclude to be set [\#15](https://github.com/treydock/puppet-module-mofed/pull/15) ([treydock](https://github.com/treydock))

## [v2.0.0](https://github.com/treydock/puppet-module-mofed/tree/v2.0.0) (2019-12-11)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.5.0...v2.0.0)

### Changed

- Change how mofed::interface resources are defined [\#11](https://github.com/treydock/puppet-module-mofed/pull/11) ([treydock](https://github.com/treydock))

### Added

- Support EL8 [\#14](https://github.com/treydock/puppet-module-mofed/pull/14) ([treydock](https://github.com/treydock))
- Module cleanup [\#13](https://github.com/treydock/puppet-module-mofed/pull/13) ([treydock](https://github.com/treydock))
- PDK convert [\#12](https://github.com/treydock/puppet-module-mofed/pull/12) ([treydock](https://github.com/treydock))

## [1.5.0](https://github.com/treydock/puppet-module-mofed/tree/1.5.0) (2019-04-26)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.4.2...1.5.0)

### Added

- Support only Puppet 5 and 6 and update module dependency ranges [\#10](https://github.com/treydock/puppet-module-mofed/pull/10) ([treydock](https://github.com/treydock))
- Move some infiniband facts to infiniband module [\#9](https://github.com/treydock/puppet-module-mofed/pull/9) ([treydock](https://github.com/treydock))

## [1.4.2](https://github.com/treydock/puppet-module-mofed/tree/1.4.2) (2018-07-31)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.4.1...1.4.2)

### Fixed

- Fix infiniband\_hca\_port\_guids when IB stack is not functional [\#8](https://github.com/treydock/puppet-module-mofed/pull/8) ([treydock](https://github.com/treydock))

## [1.4.1](https://github.com/treydock/puppet-module-mofed/tree/1.4.1) (2018-07-31)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.4.0...1.4.1)

### Added

- Document with puppet-strings [\#7](https://github.com/treydock/puppet-module-mofed/pull/7) ([treydock](https://github.com/treydock))

### Fixed

- Fix facts to not produce 'unexpected return' errors [\#6](https://github.com/treydock/puppet-module-mofed/pull/6) ([treydock](https://github.com/treydock))

## [1.4.0](https://github.com/treydock/puppet-module-mofed/tree/1.4.0) (2018-07-18)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.3.0...1.4.0)

### Added

- Add infiniband\_hcas fact and infiniband\_hca\_port\_guids fact [\#5](https://github.com/treydock/puppet-module-mofed/pull/5) ([treydock](https://github.com/treydock))

## [1.3.0](https://github.com/treydock/puppet-module-mofed/tree/1.3.0) (2018-05-18)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.2.0...1.3.0)

### Added

- Add mellanox\_ofed\_version fact [\#3](https://github.com/treydock/puppet-module-mofed/pull/3) ([treydock](https://github.com/treydock))

### Fixed

- Fix has\_mellanox\_infiniband fact to not throw error without lspci present [\#4](https://github.com/treydock/puppet-module-mofed/pull/4) ([treydock](https://github.com/treydock))

## [1.2.0](https://github.com/treydock/puppet-module-mofed/tree/1.2.0) (2017-11-13)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.1.0...1.2.0)

### Added

- Use data types for all parameters [\#2](https://github.com/treydock/puppet-module-mofed/pull/2) ([treydock](https://github.com/treydock))

## [1.1.0](https://github.com/treydock/puppet-module-mofed/tree/1.1.0) (2017-11-02)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/1.0.0...1.1.0)

### Added

- Support hiera merging extra\_packages [\#1](https://github.com/treydock/puppet-module-mofed/pull/1) ([treydock](https://github.com/treydock))

## [1.0.0](https://github.com/treydock/puppet-module-mofed/tree/1.0.0) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/0.0.1...1.0.0)

## [0.0.1](https://github.com/treydock/puppet-module-mofed/tree/0.0.1) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-mofed/compare/f8b3f5ad14953a85e148d18ec4491e09e63849af...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
