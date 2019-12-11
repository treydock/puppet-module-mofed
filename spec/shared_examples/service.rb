shared_examples 'mofed::service' do
  it do
    is_expected.to contain_service('openibd').only_with(ensure: 'running',
                                                        enable: 'true',
                                                        name: 'openibd',
                                                        hasstatus: 'true',
                                                        hasrestart: 'true')
  end
end
