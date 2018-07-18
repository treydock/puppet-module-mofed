require 'spec_helper'
require 'facter/util/mellanox_infiniband'

describe 'infiniband_hcas fact' do

  before :each do
    Facter.clear
    allow(Facter.fact(:has_mellanox_infiniband)).to receive(:value).and_return(true)
  end

  it "should return HCAs" do
    allow(Facter::Util::MellanoxInfiniband).to receive(:get_hcas).and_return(['mlx5_0','mlx5_1'])
    expect(Facter.fact(:infiniband_hcas).value).to eq(['mlx5_0','mlx5_1'])
  end

  it "should return nil for no HCAs" do
    allow(Facter::Util::MellanoxInfiniband).to receive(:get_hcas).and_return([])
    expect(Facter.fact(:infiniband_hcas).value).to be_nil
  end
end
