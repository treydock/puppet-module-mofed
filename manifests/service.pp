# Private class.
class mofed::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

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
