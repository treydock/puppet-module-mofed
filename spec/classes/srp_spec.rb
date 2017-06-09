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
        is_expected.to contain_service('srpd').with({
          :ensure     => 'running',
          :enable     => 'true',
          :hasstatus  => 'true',
          :hasrestart => 'true',
          :require    => 'Package[srptools]'
        })
      end

      context 'when ensure=disabled' do
        let(:params) {{ :ensure => 'disabled' }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_service('srpd').with_ensure('stopped') }
        it { is_expected.to contain_service('srpd').with_enable('false') }
      end

      context 'when ensure=absent' do
        let(:params) {{ :ensure => 'absent' }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('srptools').with_ensure('absent') }
        it { is_expected.to contain_rsyslog__snippet('60_srp_daemon.conf').with_ensure('absent') }
        it { is_expected.to contain_service('srpd').with_ensure('stopped') }
        it { is_expected.to contain_service('srpd').with_enable('false') }
      end

    end # end context
  end # end on_supported_os loop
end # end describe
