class ldap::install {
  package { $ldap::params::pkgs:
    ensure => installed,
  } 
}
