# @api private
class mofed::install {
  assert_private()

  if $mofed::manage_packages {
    package { 'mlnx-ofed':
      ensure => $mofed::package_ensure,
      name   => $mofed::package_name,
    }

    if $mofed::extra_packages_hiera_merge {
      $extra_packages = hiera_array('mofed::extra_packages', [])
    } else {
      $extra_packages = $mofed::extra_packages
    }

    if $extra_packages {
      ensure_packages($extra_packages)
    }
  }
}
