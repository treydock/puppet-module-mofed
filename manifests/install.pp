# Private class.
class mofed::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'mlnx-ofed':
    ensure => $mofed::package_ensure,
    name   => $mofed::package_name,
  }

  if $mofed::extra_packages {
    ensure_packages($mofed::extra_packages)
  }

}
