shared_context "mofed::install" do
  it do
    is_expected.to contain_package('mlnx-ofed').only_with({
      :ensure => 'present',
      :name   => 'mlnx-ofed-basic',
    })
  end
end
