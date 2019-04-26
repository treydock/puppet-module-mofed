class Facter::Util::MellanoxInfiniband
  # REF: http://cateee.net/lkddb/web-lkddb/INFINIBAND.html
  LSPCI_IB_REGEX = /\s15b3:/

  # lspci is a delegating helper method intended to make it easier to stub the
  # system call without affecting other calls to Facter::Core::Execution.exec
  def self.lspci(command = "lspci -n 2>/dev/null")
    #TODO: Deprecated in facter-2.0
    Facter::Util::Resolution.exec command
    #TODO: Not supported in facter < 2.0
    #Facter::Core::Execution.exec command
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
      output = self.lspci
      matches = output.scan(LSPCI_IB_REGEX)
      count = matches.flatten.reject {|s| s.nil?}.length
    end
    count
  end
end
