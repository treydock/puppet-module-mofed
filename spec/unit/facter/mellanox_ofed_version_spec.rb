require 'spec_helper'

describe 'mellanox_ofed_version fact' do
  context 'on Linux' do
    before(:each) do
      Facter.clear
      allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
    end

    it 'returns version' do
      allow(Facter::Util::Resolution).to receive(:which).and_return('/usr/bin/ofed_info')
      allow(Facter::Util::Resolution).to receive(:exec).with('ofed_info -s 2>&1').and_return("MLNX_OFED_LINUX-4.3-1.0.1.0:\n")
      expect(Facter.fact(:mellanox_ofed_version).value).to eq('4.3-1.0.1.0')
    end

    it 'does not return version if no match' do
      allow(Facter::Util::Resolution).to receive(:which).and_return('/usr/bin/ofed_info')
      allow(Facter::Util::Resolution).to receive(:exec).with('ofed_info -s 2>&1').and_return("ERROR\n")
      expect(Facter.fact(:mellanox_ofed_version).value).to be_nil
    end

    it 'does not return version if no ofed_info' do
      allow(Facter::Util::Resolution).to receive(:which).and_return(nil)
      expect(Facter.fact(:mellanox_ofed_version).value).to be_nil
    end
  end

  context 'on Windows' do
    before(:each) do
      Facter.clear
      allow(Facter.fact(:kernel)).to receive(:value).and_return('windows')
    end

    it 'is nil' do
      expect(Facter::Util::Resolution).not_to receive(:which)
      expect(Facter.fact(:mellanox_ofed_version).value).to be_nil
    end
  end
end
