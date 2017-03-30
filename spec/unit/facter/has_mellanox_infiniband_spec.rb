require 'spec_helper'

describe 'has_mellanox_infiniband fact' do

  before :each do
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    Facter::Util::Resolution.stubs(:which).with("lspci").returns("/sbin/lspci")
  end

  it "should return true when Mellanox ConnectX card" do
    Facter::Util::MellanoxInfiniband.stubs(:lspci).returns(my_fixture_read('mellanox_lspci_1'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(true)
  end

  it "should return true when QLogic card" do
    Facter::Util::MellanoxInfiniband.stubs(:lspci).returns(my_fixture_read('qlogic_lspci_1'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(false)
  end

  it "should return false when no IB device present" do
    Facter::Util::MellanoxInfiniband.stubs(:lspci).returns(my_fixture_read('noib_lspci_1'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(false)
  end

  it "should return true with Mellanox ConnectX-3 card" do
    Facter::Util::MellanoxInfiniband.stubs(:lspci).returns(my_fixture_read('mellanox_lspci_2'))
    expect(Facter.fact(:has_mellanox_infiniband).value).to eq(true)
  end
end
