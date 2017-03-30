require 'spec_helper'
require 'facter/util/file_read'
require 'facter/util/mellanox_infiniband'

describe Facter::Util::MellanoxInfiniband do

  before :each do
    Facter.clear
  end

  describe 'lspci' do
    it 'should return output' do
      Facter::Util::Resolution.expects(:exec).with('lspci -n 2>/dev/null').returns("foo")
      expect(Facter::Util::MellanoxInfiniband.lspci).to eq('foo')
    end
  end
end
