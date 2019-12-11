require 'spec_helper'

describe 'mofed' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('mofed') }

      it { is_expected.to contain_class('mofed::repo').that_comes_before('Class[mofed::install]') }
      it { is_expected.to contain_class('mofed::install').that_comes_before('Class[mofed::config]') }
      it { is_expected.to contain_class('mofed::config').that_comes_before('Class[mofed::service]') }
      it { is_expected.to contain_class('mofed::service') }

      include_context 'mofed::install'
      include_context 'mofed::config'
      include_context 'mofed::service'
    end # end context
  end # end on_supported_os loop
end # end describe
