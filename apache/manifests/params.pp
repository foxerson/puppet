class apache::params {
	case $operatingsystem {
		'Ubuntu','Debian': { 
		  $pkg='apache2'
		  $svc="apache"
		  $cfg_dir="/etc/apache2/sites-enabled"
		  }
		'RedHat', 'CentOS': { 
		  $pkg='httpd' 
		  $svc='httpd'
		  $cfg_dir="/etc/httpd/conf.d"
		  }
	}
}
