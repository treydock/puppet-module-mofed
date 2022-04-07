require 'spec_helper'

describe 'mofed::interface' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      let :title do
        'ib0'
      end

      let :default_params do
        {
          ipaddr: '192.168.1.1',
          netmask: '255.255.255.0',
        }
      end

      let :params do
        default_params
      end

      let :fixture_suffix do
        if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'].to_i >= 8
          '-no_nm_controlled'
        else
          ''
        end
      end

      it do
        is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with('ensure' => 'present',
                                                                                     'owner'   => 'root',
                                                                                     'group'   => 'root',
                                                                                     'mode'    => '0644')
      end

      it do
        is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0') \
          .with_content(my_fixture_read("ifcfg-ib0_with_connected_mode#{fixture_suffix}"))
      end

      context 'ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_ensure('absent') }
      end

      context 'enable => false' do
        let :params do
          default_params.merge(enable: false)
        end

        it { is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read("ifcfg-ib0_with_onboot_no#{fixture_suffix}")) }
      end

      context 'connected_mode => no' do
        let :params do
          default_params.merge(connected_mode: 'no')
        end

        it { is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read("ifcfg-ib0_without_connected_mode#{fixture_suffix}")) }
      end

      context 'mtu => 65520' do
        let :params do
          default_params.merge(mtu: 65_520)
        end

        it { is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0'). with_content(my_fixture_read("ifcfg-ib0_with_mtu#{fixture_suffix}")) }
      end

      context 'gateway => 192.168.1.254' do
        let :params do
          default_params.merge(gateway: '192.168.1.254')
        end

        it { is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read("ifcfg-ib0_with_gateway#{fixture_suffix}")) }
      end

      context 'bonding => true' do
        let :title do
          'ibbond0'
        end

        let :params do
          default_params.merge(bonding: true, bonding_slaves: ['ib0', 'ib1'], mtu: 65_520)
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read("ifcfg-bond-slave-ib0#{fixture_suffix}"))
          is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ib1').with_content(my_fixture_read("ifcfg-bond-slave-ib1#{fixture_suffix}"))
          is_expected.to contain_file('/etc/sysconfig/network-scripts/ifcfg-ibbond0').with_content(my_fixture_read("ifcfg-bond-master-ibbond0#{fixture_suffix}"))
        }
      end

      context 'bonding => true, no slave interfaces' do
        let :params do
          default_params.merge(bonding: true)
        end

        it { is_expected.to compile.and_raise_error(%r{No slave interfaces given for bonding interface}) }
      end
    end
  end
end
