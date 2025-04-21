# frozen_string_literal: true

require 'spec_helper'

describe 'mofed::interface' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
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

      let :nm_controlled do
        if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'].to_s == '7'
          { 'NM_CONTROLLED' => 'no' }
        else
          {}
        end
      end

      it do
        is_expected.to contain_network_config('ib0').with(
          ensure: 'present',
          onboot: true,
          ipaddress: '192.168.1.1',
          netmask: '255.255.255.0',
          mtu: nil,
          method: 'static',
          hotplug: false,
          options: {
            'TYPE' => 'Infiniband',
            'CONNECTED_MODE' => 'yes',
          }.merge(nm_controlled),
        )
      end

      context 'when ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_network_config('ib0').with_ensure('absent') }
      end

      context 'when enable => false' do
        let :params do
          default_params.merge(enable: false)
        end

        it { is_expected.to contain_network_config('ib0').with_onboot(false) }
      end

      context 'when connected_mode => no' do
        let :params do
          default_params.merge(connected_mode: 'no')
        end

        it { is_expected.to contain_network_config('ib0').with_options({ 'TYPE' => 'Infiniband', 'CONNECTED_MODE' => 'no' }.merge(nm_controlled)) }
      end

      context 'when mtu => 65520' do
        let :params do
          default_params.merge(mtu: 65_520)
        end

        it { is_expected.to contain_network_config('ib0').with_mtu(65_520) }
      end

      context 'when gateway => 192.168.1.254' do
        let :params do
          default_params.merge(gateway: '192.168.1.254')
        end

        it { is_expected.to contain_network_config('ib0').with_options({ 'TYPE' => 'Infiniband', 'GATEWAY' => '192.168.1.254', 'CONNECTED_MODE' => 'yes' }.merge(nm_controlled)) }
      end

      context 'when bonding => true' do
        let :title do
          'ibbond0'
        end

        let :params do
          default_params.merge(bonding: true, bonding_slaves: ['ib0', 'ib1'], mtu: 65_520)
        end

        it do
          is_expected.to contain_network_config('ib0').with(
            ensure: 'present',
            onboot: true,
            mtu: 65_520,
            method: 'static',
            hotplug: false,
            options: {
              'TYPE' => 'Infiniband',
              'MASTER' => 'ibbond0',
              'SLAVE' => 'yes',
              'CONNECTED_MODE' => 'yes',
            }.merge(nm_controlled),
          )
        end

        it do
          is_expected.to contain_network_config('ib1').with(
            ensure: 'present',
            onboot: true,
            mtu: 65_520,
            method: 'static',
            hotplug: false,
            options: {
              'TYPE' => 'Infiniband',
              'MASTER' => 'ibbond0',
              'SLAVE' => 'yes',
              'CONNECTED_MODE' => 'yes',
            }.merge(nm_controlled),
          )
        end

        it do
          is_expected.to contain_network_config('ibbond0').with(
            ensure: 'present',
            onboot: true,
            mtu: 65_520,
            method: 'static',
            hotplug: false,
            options: {
              'TYPE' => 'Bond',
              'BONDING_MASTER' => 'yes',
              'BONDING_OPTS' => 'mode=active-backup miimon=100',
              'CONNECTED_MODE' => 'yes',
            }.merge(nm_controlled),
          )
        end
      end

      context 'when bonding => true, no slave interfaces' do
        let :params do
          default_params.merge(bonding: true)
        end

        it { is_expected.to compile.and_raise_error(%r{No slave interfaces given for bonding interface}) }
      end
    end
  end
end
