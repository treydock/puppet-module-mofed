# Private class.
class mofed::repo {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $mofed::manage_repo {
    case $::osfamily {
      'RedHat': {
        yumrepo { 'mlnx_ofed':
          descr    => 'MLNX_OFED Repository',
          baseurl  => $mofed::repo_baseurl,
          enabled  => '1',
          gpgkey   => $mofed::repo_gpgkey,
          gpgcheck => '1',
        }
      }
      default: {
        # Do nothing
      }
    }
  }

}
