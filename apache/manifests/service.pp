class apache::service {
  service { $apache::params::svc:
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["apache::install"],
    }
}