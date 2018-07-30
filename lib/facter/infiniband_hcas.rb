# Fact: infiniband_hcas
#
# Purpose: Determine list of Infiniband HCAs
#
# Resolution:
#   Returns Array of HCA names.
#

require 'facter/util/mellanox_infiniband'

Facter.add(:infiniband_hcas) do
  confine :has_mellanox_infiniband => true
  setcode do
    hcas = Facter::Util::MellanoxInfiniband.get_hcas
    if hcas.empty?
      nil
    else
      hcas
    end
  end
end
