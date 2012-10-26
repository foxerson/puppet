class ganglia-gmetad::params {
  case $operatingsystem {
    'Ubuntu','Debian': { 
        $pkg="gmetad"
        $svc="gmetad" 
    }
    # todo: redhat
  }   
}