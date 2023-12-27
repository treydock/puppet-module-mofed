# frozen_string_literal: true

# Fact: has_mellanox_infiniband
#
# Purpose: Determine if the system's hardware supports Mellanox InfiniBand.
#
# Resolution:
#   Returns true or false based on output from `lspci`.
#

require 'facter/util/mellanox_infiniband'

Facter.add(:has_mellanox_infiniband) do
  confine kernel: 'Linux'
  setcode do
    ib_device_count = Facter::Util::MellanoxInfiniband.count_ib_devices
    ib_device_count.positive?
  end
end
