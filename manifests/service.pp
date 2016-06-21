# Private class.
class mofed::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'openibd':
    ensure     => $mofed::openibd_service_ensure,
    enable     => $mofed::openibd_service_enable,
    name       => $mofed::openibd_service_name,
    hasstatus  => $mofed::openibd_service_hasstatus,
    hasrestart => $mofed::openibd_service_hasrestart,
  }

}
