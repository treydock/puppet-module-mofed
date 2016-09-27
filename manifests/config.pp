# Private class.
class mofed::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $mofed::manage_config {
    Shellvar {
      ensure  => present,
      target  => $mofed::openib_config_path,
    }

    create_resources('shellvar', $mofed::openib_shellvars)
  }

}
