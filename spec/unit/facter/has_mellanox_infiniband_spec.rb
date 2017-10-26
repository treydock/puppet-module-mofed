require 'spec_helper'
require 'facter/util/mellanox_infiniband'

describe 'has_mellanox_infiniband fact' do

  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
    allow(Facter::Util::Resolution).to receive(:which).and_return('/sbin/lspci')
  end

  it "should return true when Mellanox ConnectX card" do
    allow(Facter::Util::MellanoxInfiniband).to receive(:lspci).and_return(my_fixture_read('mellanox_lspci_1'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(true)
  end

  it "should return true when QLogic card" do
    allow(Facter::Util::MellanoxInfiniband).to receive(:lspci).and_return(my_fixture_read('qlogic_lspci_1'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(false)
  end

  it "should return false when no IB device present" do
    allow(Facter::Util::MellanoxInfiniband).to receive(:lspci).and_return(my_fixture_read('noib_lspci_1'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(false)
  end

  it "should return true with Mellanox ConnectX-3 card" do
    allow(Facter::Util::MellanoxInfiniband).to receive(:lspci).and_return(my_fixture_read('mellanox_lspci_2'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(true)
  end
end
