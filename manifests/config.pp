# @api private
class mofed::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $mofed::manage_config {
    $_shellvar_defaults = {
      ensure  => present,
      target  => $mofed::openib_config_path,
      notify  => $mofed::openib_shellvar_notify,
    }

    create_resources('shellvar', $mofed::openib_shellvars, $_shellvar_defaults)
  }

}
