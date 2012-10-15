class apache::instal {
  package { $apache::params::pkg: 
    ensure => present,
  }
}
