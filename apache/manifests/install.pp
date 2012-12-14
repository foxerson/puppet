class apache::install {
  package { $apache::params::pkg: 
    ensure => present,
  }
  
  # prepare the service/lbrewww keytab in case afs will server pages
  file { "/etc/lbrewww.keytab":
    source => "puppet:///modules/apache/lbrewww.keytab",
    ensure => present,
    mode => 600,
    owner => root,
    group => root,  
  }
  
  # TODO: add wrapper init script here
  # TODO: add monit to monitor k5start
}
