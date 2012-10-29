class ganglia-gmond::service {
  
  service { $ganglia-gmond::params::svc: 
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["ganglia-gmond::install"],
  }
}