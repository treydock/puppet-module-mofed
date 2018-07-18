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

  # Returns array of HCAs on the system
  #
  # @return [Array]
  #
  # @api private
  def self.get_hcas
    hcas = []
    if File.directory?('/sys/class/infiniband')
      Dir.glob('/sys/class/infiniband/*').each do |dir|
        hca = File.basename(dir)
        hcas << hca
      end
    end
    hcas
  end

  #
  def self.get_hca_port_guids(hca)
    port_guids = {}
    if ! Facter::Util::Resolution.which('ibstat')
      return {}
    end
    output = Facter::Util::Resolution.exec("ibstat -p #{hca}")
    output.each_line.with_index do |line, index|
      guid = line.strip()
      port = index + 1
      port_guids[port.to_s] = guid
    end
    port_guids
  end
end
