class openafs::params {
  case $operatingsystem {
		RedHat: {
      # creates the openafs repository according to
      # version specifies below. Visit       
      # yum.stanford.edu/mrepo for the latest release
      $el = regsubst($kernelrelease,'^\d{1}\.\d{1}\.\d+-\d+\.\d+\.\d+\.(el[5-7])\S*$','\1','I')        
      openafs::repo { '1.6.1':
         release => '1.6.1',
         rh_base => $el ? {
            'el5' => 'EL5',
            'el6' => 'EL6',
            'el7' => 'EL7',
            default => 'EL6',
         }
		  }  
		}
    # Ubuntu,Debian: {
    #   # Required for wallet-client
    #   file { "/etc/apt/sources.list.d/stanford.list":
    #     ensure => present,
    #         owner => "root",
    #         group => "root",
    #         mode => 0644,
    #         content => "deb http://debian.stanford.edu/debian-stanford stable main",    
    #   }
    #   
    #   # It's OK to install unsigned packages
    #       file { "/etc/apt/apt.conf.d/99auth":       
    #          owner     => root,
    #          group     => root,
    #          content   => "APT::Get::AllowUnauthenticated yes;",
    #          mode      => 644,
    #          subscribe => File["/etc/apt/sources.list.d/stanford.list"],
    #       } 
    # }
	}
}

