require 'spec_helper'

describe 'mofed::opensm' do
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

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('mofed::opensm') }
      it { is_expected.to contain_class('mofed::params') }
      it { is_expected.to contain_class('mofed') }

      it do
        is_expected.to contain_package('opensm').with({
          :ensure  => 'present',
          :require => 'Class[Mofed::Repo]'
        })
      end

      it do
        is_expected.to contain_file('/etc/sysconfig/opensm').with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :require => 'Package[opensm]',
        })
      end

      it do
        verify_exact_contents(catalogue, '/etc/sysconfig/opensm', [
          'SWEEP=10'
        ])
      end

      it do
        is_expected.to contain_service('opensmd').with({
          :ensure     => 'running',
          :enable     => 'true',
          :hasstatus  => 'true',
          :hasrestart => 'true',
          :subscribe  => 'File[/etc/sysconfig/opensm]'
        })
      end

      context 'when ports defined' do
        let(:params) {{
          :ports => ['mlx5_0 1', 'mlx5_0 2'],
        }}

        it { is_expected.to compile.with_all_deps }

        it do
          verify_exact_contents(catalogue, '/etc/sysconfig/opensm', [
            'SWEEP=10',
            'PORT_1=mlx5_0 1',
            'PORT_2=mlx5_0 2'
          ])
        end

        it do
          is_expected.to contain_service('opensmd').with({
            :ensure     => 'stopped',
            :enable     => 'false',
            :hasstatus  => 'true',
            :hasrestart => 'true',
            :require    => 'Package[opensm]',
          })
        end

        if facts[:operatingsystemrelease].to_i >= 7.0
          it do
            is_expected.to contain_systemd__unit_file('opensmd@.service')
          end

          it do
            is_expected.to contain_service('opensmd@1').with({
              :ensure     => 'running',
              :enable     => 'true',
              :hasstatus  => 'true',
              :hasrestart => 'true',
              :subscribe  => 'File[/etc/sysconfig/opensm]'
            })
          end

          it do
            is_expected.to contain_service('opensmd@2').with({
              :ensure     => 'running',
              :enable     => 'true',
              :hasstatus  => 'true',
              :hasrestart => 'true',
              :subscribe  => 'File[/etc/sysconfig/opensm]'
            })
          end
        end
      end

    end # end context
  end # end on_supported_os loop
end # end describe
