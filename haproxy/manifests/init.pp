class haproxy {
  
  # same namevar for both RH and Ubuntu.
  package { 'haproxy':
    ensure => installed, 
  }
}