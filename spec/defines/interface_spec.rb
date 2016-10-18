require 'spec_helper'

describe 'mofed::interface' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/dne',
        })
      end

      let :title do
        'ib0'
      end
  
      let :default_params do
        {
          :ipaddr   => '192.168.1.1',
          :netmask  => '255.255.255.0',
        }
      end

      let :params do
        default_params
      end

      it do
        should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with({
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'notify'  => nil,
        })
      end

      it do
        should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0') \
          .with_content(my_fixture_read('ifcfg-ib0_with_connected_mode'))
      end

      context 'ensure => absent' do
        let :params do
          default_params.merge({:ensure => 'absent'})
        end

        it { should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_ensure('absent') }
      end

      context 'enable => no' do
        let :params do
          default_params.merge({:enable => 'no'})
        end

        it { should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read('ifcfg-ib0_with_onboot_no')) }
      end

      context 'connected_mode => no' do
        let :params do
          default_params.merge({:connected_mode => 'no'})
        end

        it { should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read('ifcfg-ib0_without_connected_mode')) }
      end

      context 'mtu => 65520' do
        let :params do
          default_params.merge({:mtu => '65520'})
        end

        it { should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0'). with_content(my_fixture_read('ifcfg-ib0_with_mtu')) }
      end

      context 'gateway => 192.168.1.254' do
        let :params do
          default_params.merge({:gateway => '192.168.1.254'})
        end

        it { should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_content(my_fixture_read('ifcfg-ib0_with_gateway')) }
      end

      context 'restart_service => true' do
         let(:pre_condition) do
            "class { 'mofed': restart_service => true }"
         end

         it { should contain_file('/etc/sysconfig/network-scripts/ifcfg-ib0').with_notify('Service[openibd]') }
      end
    end
  end
end

