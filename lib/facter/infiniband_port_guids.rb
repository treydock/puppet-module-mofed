# Fact: infiniband_hca_port_guids
#
# Purpose: Determine list of Infiniband HCA port GUIDs
#
# Resolution:
#   Returns Hash of HCA port's and their GUIDs.
#

require 'facter/util/mellanox_infiniband'

Facter.add(:infiniband_hca_port_guids) do
  confine :has_mellanox_infiniband => true
  setcode do
    hcas = Facter.fact(:infiniband_hcas).value
    return nil if hcas.nil? || hcas.empty?
    hca_port_guids = {}
    hcas.each do |hca|
      port_guids = Facter::Util::MellanoxInfiniband.get_hca_port_guids(hca)
      if ! port_guids.empty?
        hca_port_guids[hca] = port_guids
      end
    end
    hca_port_guids
  end
end
