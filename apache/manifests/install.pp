class apache::install {
  package { $apache::params::pkg: 
    ensure => present,
  }
}
