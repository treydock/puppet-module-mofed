# frozen_string_literal: true

require 'spec_helper'

describe 'mofed::opensm' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('mofed::opensm') }
      it { is_expected.to contain_class('mofed') }

      it do
        is_expected.to contain_package('opensm').with(ensure: 'present',
                                                      require: 'Class[Mofed::Repo]')
      end

      it do
        is_expected.to contain_file('/etc/sysconfig/opensm').with(ensure: 'file',
                                                                  owner: 'root',
                                                                  group: 'root',
                                                                  mode: '0644',
                                                                  require: 'Package[opensm]')
      end

      it do
        verify_exact_contents(catalogue, '/etc/sysconfig/opensm', [
                                'SWEEP=10'
                              ])
      end

      it do
        is_expected.to contain_service('opensmd').with(ensure: 'running',
                                                       enable: 'true',
                                                       hasstatus: 'true',
                                                       hasrestart: 'true',
                                                       subscribe: 'File[/etc/sysconfig/opensm]')
      end

      it do
        is_expected.not_to contain_systemd__unit_file('opensmd@.service')
      end

      context 'when ports defined' do
        let(:params) do
          {
            ports: ['mlx5_0 1', 'mlx5_0 2']
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          verify_exact_contents(catalogue, '/etc/sysconfig/opensm', [
                                  'SWEEP=10',
                                  'PORT_1=mlx5_0 1',
                                  'PORT_2=mlx5_0 2'
                                ])
        end

        it do
          is_expected.to contain_service('opensmd').with(ensure: 'stopped',
                                                         enable: 'false',
                                                         hasstatus: 'true',
                                                         hasrestart: 'true',
                                                         require: 'Package[opensm]')
        end

        if facts[:operatingsystemrelease].to_i >= 7.0
          it do
            is_expected.to contain_systemd__unit_file('opensmd@.service').with_ensure('file')
          end

          it do
            is_expected.to contain_service('opensmd@1').with(ensure: 'running',
                                                             enable: 'true',
                                                             hasstatus: 'true',
                                                             hasrestart: 'true',
                                                             subscribe: ['File[/etc/sysconfig/opensm]', 'Systemd::Unit_file[opensmd@.service]'])
          end

          it do
            is_expected.to contain_service('opensmd@2').with(ensure: 'running',
                                                             enable: 'true',
                                                             hasstatus: 'true',
                                                             hasrestart: 'true',
                                                             subscribe: ['File[/etc/sysconfig/opensm]', 'Systemd::Unit_file[opensmd@.service]'])
          end
        end
      end

      context 'when ensure=disabled' do
        let(:params) { { ensure: 'disabled' } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_service('opensmd').with_ensure('stopped') }
        it { is_expected.to contain_service('opensmd').with_enable('false') }

        context 'when ports defined' do
          let(:params) do
            {
              ensure: 'disabled',
              ports: ['mlx5_0 1', 'mlx5_0 2']
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_service('opensmd').with_ensure('stopped') }
          it { is_expected.to contain_service('opensmd').with_enable('false') }

          if facts[:operatingsystemrelease].to_i >= 7.0
            it { is_expected.to contain_service('opensmd@1').with_ensure('stopped') }
            it { is_expected.to contain_service('opensmd@1').with_enable('false') }
            it { is_expected.to contain_service('opensmd@2').with_ensure('stopped') }
            it { is_expected.to contain_service('opensmd@2').with_enable('false') }
          end
        end
      end

      context 'when ensure=absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('opensm').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/sysconfig/opensm').with_ensure('absent') }
        it { is_expected.to contain_service('opensmd').with_ensure('stopped') }
        it { is_expected.to contain_service('opensmd').with_enable('false') }

        context 'when ports defined' do
          let(:params) do
            {
              ensure: 'absent',
              ports: ['mlx5_0 1', 'mlx5_0 2']
            }
          end

          it { is_expected.to compile.with_all_deps }

          if facts[:operatingsystemrelease].to_i >= 7.0
            it { is_expected.to contain_systemd__unit_file('opensmd@.service').with_ensure('absent') }
            it { is_expected.to contain_service('opensmd@1').with_ensure('stopped') }
            it { is_expected.to contain_service('opensmd@1').with_enable('false') }
            it { is_expected.to contain_service('opensmd@2').with_ensure('stopped') }
            it { is_expected.to contain_service('opensmd@2').with_enable('false') }
          end
        end
      end
    end
  end
end
