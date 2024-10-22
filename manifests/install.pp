# @api private
class mofed::install {
  assert_private()

  if $mofed::manage_packages {
    package { 'mlnx-ofed':
      ensure => $mofed::package_ensure,
      name   => $mofed::package_name,
    }

    if $mofed::extra_packages_hiera_merge {
      $extra_packages = lookup('mofed::extra_packages', Array, 'unique', [])
    } else {
      $extra_packages = $mofed::extra_packages
    }

    if $extra_packages {
      stdlib::ensure_packages($extra_packages)
    }
  }
}
