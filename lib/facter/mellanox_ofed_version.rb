# frozen_string_literal: true

# Fact: mellanox_ofed_version
#
# Purpose: Determine version of Mellanox OFED installed
#
# Resolution:
#   Returns value based on output from ofed_info
#

Facter.add(:mellanox_ofed_version) do
  confine kernel: 'Linux'
  setcode do
    if Facter::Util::Resolution.which('ofed_info')
      output = Facter::Util::Resolution.exec('ofed_info -s 2>&1')
      if output =~ %r{^MLNX_OFED_LINUX-(.*):$}
        Regexp.last_match(1)
      end
    end
  end
end
