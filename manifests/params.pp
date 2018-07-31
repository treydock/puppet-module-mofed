# @api private
class mofed::params {

  case $::osfamily {
    'RedHat': {
      $package_name                 = 'mlnx-ofed-basic'
      $openibd_service_name         = 'openibd'
      $openibd_service_hasstatus    = true
      $openibd_service_hasrestart   = true
      $openib_config_path           = '/etc/infiniband/openib.conf'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
