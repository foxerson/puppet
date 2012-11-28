class openafs::config {
  case $operatingsystem {
    Ubuntu,Debian: {
      $cfgdir = "/etc/openafs"
    }
    RedHat,Fedora,Centos: {
      $cfgdir = "/usr/vice/etc"
    }
  }
  
  File {
  	ensure => present,
  	owner => "root",
  	group => "root",
  	mode => 0644,
  	require => Class["openafs::install"],
  	notify => Class["openafs::service"],
  }
  
  file {"${cfgdir}/ThisCell":
    content => "ir.stanford.edu",
  }
  
  file {"${cfgdir}/CellAlias":
    content => "ir.stanford.edu ir",
  }  
}