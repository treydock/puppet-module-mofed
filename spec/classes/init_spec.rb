# frozen_string_literal: true

require 'spec_helper'

describe 'mofed' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('mofed') }

      it { is_expected.to contain_class('mofed::repo').that_comes_before('Class[mofed::install]') }
      it { is_expected.to contain_class('mofed::install').that_comes_before('Class[mofed::config]') }
      it { is_expected.to contain_class('mofed::config').that_comes_before('Class[mofed::service]') }
      it { is_expected.to contain_class('mofed::service') }

      describe 'mofed::install' do
        it do
          is_expected.to contain_package('mlnx-ofed').only_with(
            ensure: 'present',
            name: 'mlnx-ofed-basic',
          )
        end
      end

      describe 'mofed::service' do
        it do
          is_expected.to contain_service('openibd').only_with(
            ensure: 'running',
            enable: 'true',
            name: 'openibd',
            hasstatus: 'true',
            hasrestart: 'true',
          )
        end
      end
    end
  end
end
