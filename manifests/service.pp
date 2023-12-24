# @api private
class mofed::service {
  assert_private()

  if $mofed::openibd_service_enable in ['UNSET', 'undef'] {
    $_enable = undef
  } else {
    $_enable = $mofed::openibd_service_enable
  }

  if $mofed::manage_service {
    service { 'openibd':
      ensure     => $mofed::openibd_service_ensure,
      enable     => $_enable,
      name       => $mofed::openibd_service_name,
      hasstatus  => $mofed::openibd_service_hasstatus,
      hasrestart => $mofed::openibd_service_hasrestart,
    }
  }
}
