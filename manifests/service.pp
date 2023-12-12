# @api private
class mofed::service {
  assert_private()

  if $mofed::manage_service {
    service { 'openibd':
      ensure     => $mofed::openibd_service_ensure,
      enable     => $mofed::openibd_service_enable,
      name       => $mofed::openibd_service_name,
      hasstatus  => $mofed::openibd_service_hasstatus,
      hasrestart => $mofed::openibd_service_hasrestart,
    }
  }
}
