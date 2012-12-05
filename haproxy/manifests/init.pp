class haproxy {
  
  # same namevar for both RH and Ubuntu.
  package { 'haproxy':
    ensure => installed, 
  }
  
  service { 'haproxy':
    ensure => 'running',
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Package['haproxy'],
  }
}