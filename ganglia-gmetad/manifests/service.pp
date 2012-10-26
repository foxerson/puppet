class ganglia-gmetad::service {
  service { $ganglia-gmetad::params::svc: 
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enabled => true,
    require => Class["ganglia-gmetad::install"],
    }
}