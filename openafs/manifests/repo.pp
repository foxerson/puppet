define openafs::repo($release,$rh_base) {
  # add openafs red hat repository. User must update install.pp to the
  # latest version available at yum.stanford.edu/mrepo
  
  # Remove older repos on Red Hat
  # exec { "rm -rf /etc/yum.repos.d/openafs*.repo":
  #       path => "/usr/bin:/usr/sbin:/bin",
  #       onlyif => "test ! -f openafs-${release}.repo",
  #   }
  yumrepo { "openafs-${name}":
    baseurl => "http://yum.stanford.edu/mrepo/openafs-${release}-${rh_base}-\$basearch/RPMS.updates",
    descr => "OpenAFS ${release} packages",
    enabled => 1,
    protect => 0,
    gpgkey => 'http://yum.stanford.edu/STANFORD-GPG-KEY',
    gpgcheck => 1,
  }
}