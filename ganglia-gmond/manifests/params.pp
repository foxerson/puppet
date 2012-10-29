class ganglia-gmond::params {
  case $operatingsystem {
    'Ubuntu','Debian': { 
        $pkg="ganglia-monitor"
        $svc="ganglia-monitor"
        $cfgdir="/etc/ganglia" 
    }
    # todo: redhat
  }   
}