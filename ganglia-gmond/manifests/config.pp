class ganglia-gmond::config {
  
  file { "${ganglia-gmond::params::cfg}/gmond.conf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '664',
    require => Class["ganglia-gmond::install"],
    notify => Class["ganglia-gmond::service"],
  }
}