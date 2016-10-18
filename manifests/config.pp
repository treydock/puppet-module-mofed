# Private class.
class mofed::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $mofed::manage_config {
    if $mofed::restart_service {
      $_notify = Service['openibd']
    } else {
      $_notify = undef
    }

    $_shellvar_defaults = {
      ensure  => present,
      target  => $mofed::openib_config_path,
      notify  => $_notify,
    }

    create_resources('shellvar', $mofed::openib_shellvars, $_shellvar_defaults)
  }

}
