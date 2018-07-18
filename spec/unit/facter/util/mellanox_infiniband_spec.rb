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

  describe 'count_ib_devices' do
    it 'should return count' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return('/usr/bin/lspci')
      allow(described_class).to receive(:lspci).and_return(my_fixture_read('mellanox_lspci_1'))
      expect(described_class.count_ib_devices).to eq(1)
    end

    it 'should return 0 count for noib' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return('/usr/bin/lspci')
      allow(described_class).to receive(:lspci).and_return(my_fixture_read('noib_lspci_1'))
      expect(described_class.count_ib_devices).to eq(0)
    end

    it 'should return 0 count for qlogic' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return('/usr/bin/lspci')
      allow(described_class).to receive(:lspci).and_return(my_fixture_read('qlogic_lspci_1'))
      expect(described_class.count_ib_devices).to eq(0)
    end

    it 'should not return count if no lspci' do
      allow(Facter::Util::Resolution).to receive(:which).with('lspci').and_return(nil)
      expect(described_class).not_to receive(:lspci)
      expect(described_class.count_ib_devices).to eq(0)
    end
  end

  describe 'get_hcas' do
    it 'should return HCAs' do
      allow(File).to receive(:directory?).with('/sys/class/infiniband').and_return(true)
      allow(Dir).to receive(:glob).with('/sys/class/infiniband/*').and_return(['/sys/class/infiniband/mlx5_0', '/sys/class/infiniband/mlx5_1'])
      expect(described_class.get_hcas).to eq(['mlx5_0','mlx5_1'])
    end

    it 'should not return HCAs with no infiniband' do
      allow(File).to receive(:directory?).with('/sys/class/infiniband').and_return(false)
      expect(described_class.get_hcas).to eq([])
    end
  end

  describe 'get_hca_port_guids' do
    it 'should return port GUIDs' do
      allow(Facter::Util::Resolution).to receive(:which).with('ibstat').and_return('/usr/sbin/ibstat')
      allow(Facter::Util::Resolution).to receive(:exec).with('ibstat -p mlx5_0').and_return("0x0202c9fffe557aae\n0x0202c9fffe557aaf\n")
      expect(described_class.get_hca_port_guids('mlx5_0')).to eq({'1' => '0x0202c9fffe557aae', '2' => '0x0202c9fffe557aaf'})
    end

    it 'should return nothing without ibstat' do
      allow(Facter::Util::Resolution).to receive(:which).with('ibstat').and_return(nil)
      expect(Facter::Util::Resolution).not_to receive(:exec)
      expect(described_class.get_hca_port_guids('mlx5_0')).to eq({})
    end
  end
end
