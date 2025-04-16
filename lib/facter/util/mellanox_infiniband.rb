# frozen_string_literal: true

# Class for Mellanox Infiniband fact functions
class Facter::Util::MellanoxInfiniband
  LSPCI_IB_REGEX = %r{(Network|Infiniband) controller: Mellanox Technologies}.freeze

  # lspci is a delegating helper method intended to make it easier to stub the
  # system call without affecting other calls to Facter::Core::Execution.exec
  def self.lspci(command = 'lspci 2>/dev/null')
    # TODO: Deprecated in facter-2.0
    Facter::Util::Resolution.exec command
    # TODO: Not supported in facter < 2.0
    # Facter::Core::Execution.exec command
  end

  # Returns the number of InfiniBand interfaces found
  # in lspci output
  #
  # @return [Integer]
  #
  # @api private
  def self.count_ib_devices
    count = 0
    if Facter::Util::Resolution.which('lspci')
      output = lspci
      matches = output.scan(LSPCI_IB_REGEX)
      count = matches.flatten.reject { |s| s.nil? }.length
    end
    count
  end
end
