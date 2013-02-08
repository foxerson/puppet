class ldap::service {
  service { "nscd":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["ldap::install"], 
  }

  service { "nslcd":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["ldap::install"], 
  }
}
