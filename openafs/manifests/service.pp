class openafs::service {
  service { "openafs-client": 
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["openafs::install"],
  }
}