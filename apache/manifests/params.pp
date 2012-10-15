class apache::params {
	case $operatingsystem {
		'Ubuntu','Debian': { 
		  $pkg='apache2'
		  $svc="apache"
		  }
		'RedHat', 'CentOS': { 
		  $pkg='httpd' 
		  $svc='httpd'
		  }
	}
}
