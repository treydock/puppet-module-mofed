require 'spec_helper'

describe 'mofed::srp' do
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

      it { is_expected.to create_class('mofed::srp') }
      it { is_expected.to contain_class('mofed::params') }
      it { is_expected.to contain_class('mofed') }

      it do
        is_expected.to contain_package('srptools').with({
          :ensure  => 'present',
          :require => 'Class[Mofed::Repo]'
        })
      end

      it do
        is_expected.to contain_shellvar('SRP_LOAD').with({
          :ensure => 'present',
          :target => '/etc/infiniband/openib.conf',
          :value  => 'yes',
          #:notify => 'Service[openibd]',
        })
      end

      it do
        is_expected.to contain_file('/etc/rsyslog.d/srp_daemon.conf').with({
          :ensure  => 'absent',
          :require => 'Package[srptools]',
        })
      end

      it do
        is_expected.to contain_rsyslog__snippet('60_srp_daemon.conf').with({
          :ensure  => 'file',
          :require => 'Package[srptools]',
        })
      end

      it do
        is_expected.to contain_file('/etc/srp_daemon.conf').with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :require => 'Package[srptools]',
        })
      end

      it do
        verify_exact_contents(catalogue, '/etc/srp_daemon.conf', [])
      end

      it do
        is_expected.to contain_file('/etc/sysconfig/srpd').with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :require => 'Package[srptools]',
        })
      end

      it do
        verify_exact_contents(catalogue, '/etc/sysconfig/srpd', [])
      end

      it do
        is_expected.to contain_service('srpd').with({
          :ensure     => 'running',
          :enable     => 'true',
          :hasstatus  => 'true',
          :hasrestart => 'true',
          :require    => 'Package[srptools]'
        })
      end

      it do
        is_expected.not_to contain_systemd__unit_file('srpd@.service')
      end

      context 'when ports defined' do
        let(:params) {{
          :ports => ['mlx5_0 1', 'mlx5_0 2']
        }}

        it { is_expected.to compile.with_all_deps }

        it do
          verify_exact_contents(catalogue, '/etc/sysconfig/srpd', [
            'PORT_1=mlx5_0 1',
            'PORT_2=mlx5_0 2'
          ])
        end

        it do
          is_expected.to contain_service('srpd').with({
            :ensure     => 'stopped',
            :enable     => 'false',
            :hasstatus  => 'true',
            :hasrestart => 'true',
            :require    => 'Package[srptools]',
          })
        end

        if facts[:operatingsystemrelease].to_i >= 7.0
          it do
            is_expected.to contain_systemd__unit_file('srpd@.service').with_ensure('file')
          end

          it do
            is_expected.to contain_service('srpd@1').with({
              :ensure     => 'running',
              :enable     => 'true',
              :hasstatus  => 'true',
              :hasrestart => 'true',
              :require    => 'Exec[systemctl-daemon-reload]',
              :subscribe  => ['File[/etc/sysconfig/srpd]', 'File[/etc/srp_daemon.conf]', 'Systemd::Unit_file[srpd@.service]']
            })
          end

          it do
            is_expected.to contain_service('srpd@2').with({
              :ensure     => 'running',
              :enable     => 'true',
              :hasstatus  => 'true',
              :hasrestart => 'true',
              :require    => 'Exec[systemctl-daemon-reload]',
              :subscribe  => ['File[/etc/sysconfig/srpd]', 'File[/etc/srp_daemon.conf]', 'Systemd::Unit_file[srpd@.service]']
            })
          end
        end
      end

      context 'when ensure=disabled' do
        let(:params) {{ :ensure => 'disabled' }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_shellvar('SRP_LOAD').with_value('yes') }
        it { is_expected.to contain_service('srpd').with_ensure('stopped') }
        it { is_expected.to contain_service('srpd').with_enable('false') }

        context 'when ports defined' do
          let(:params) {{
            :ensure => 'disabled',
            :ports => ['mlx5_0 1', 'mlx5_0 2']
          }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_service('srpd').with_ensure('stopped') }
          it { is_expected.to contain_service('srpd').with_enable('false') }

          if facts[:operatingsystemrelease].to_i >= 7.0
            it { is_expected.to contain_service('srpd@1').with_ensure('stopped') }
            it { is_expected.to contain_service('srpd@1').with_enable('false') }
            it { is_expected.to contain_service('srpd@2').with_ensure('stopped') }
            it { is_expected.to contain_service('srpd@2').with_enable('false') }
          end
        end
      end

      context 'when ensure=absent' do
        let(:params) {{ :ensure => 'absent' }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('srptools').with_ensure('absent') }
        it { is_expected.to contain_shellvar('SRP_LOAD').with_value('no') }
        it { is_expected.to contain_rsyslog__snippet('60_srp_daemon.conf').with_ensure('absent') }
        it { is_expected.to contain_service('srpd').with_ensure('stopped') }
        it { is_expected.to contain_service('srpd').with_enable('false') }

        context 'when ports defined' do
          let(:params) {{
            :ensure => 'absent',
            :ports => ['mlx5_0 1', 'mlx5_0 2']
          }}

          it { is_expected.to compile.with_all_deps }

          if facts[:operatingsystemrelease].to_i >= 7.0
            it { is_expected.to contain_systemd__unit_file('srpd@.service').with_ensure('absent') }
            it { is_expected.to contain_service('srpd@1').with_ensure('stopped') }
            it { is_expected.to contain_service('srpd@1').with_enable('false') }
            it { is_expected.to contain_service('srpd@2').with_ensure('stopped') }
            it { is_expected.to contain_service('srpd@2').with_enable('false') }
          end
        end
      end

    end # end context
  end # end on_supported_os loop
end # end describe
