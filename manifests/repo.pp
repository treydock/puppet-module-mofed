# @api private
class mofed::repo {
  assert_private()

  if $mofed::manage_repo {
    case $facts['os']['family'] {
      'RedHat': {
        yumrepo { 'mlnx_ofed':
          descr    => 'MLNX_OFED Repository',
          baseurl  => $mofed::repo_baseurl,
          enabled  => '1',
          gpgkey   => $mofed::repo_gpgkey,
          gpgcheck => $mofed::repo_gpgcheck,
          exclude  => $mofed::repo_exclude,
          priority => $mofed::repo_priority,
        }
      }
      default: {
        # Do nothing
      }
    }
  }
}
