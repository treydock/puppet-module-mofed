require 'spec_helper'
require 'facter/util/file_read'
require 'facter/util/mellanox_infiniband'

describe Facter::Util::MellanoxInfiniband do

  before :each do
    Facter.clear
  end

  describe 'lspci' do
    it 'should return output' do
      expect(Facter::Util::Resolution).to receive(:exec).with('lspci -n 2>/dev/null').and_return('foo')
      expect(Facter::Util::MellanoxInfiniband.lspci).to eq('foo')
    end
  end
end
