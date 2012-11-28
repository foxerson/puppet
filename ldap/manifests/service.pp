class ldap::service {
  service { "nslcd":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["ldap::install"], 
  }
}
