class apache {
  case $operatingsystem {
		'Ubuntu','Debian': { 
		  $pkg='apache2'
		  $svc='apache2'
		  $cfg_dir="/etc/apache2/conf.d"
		}
		'RedHat', 'CentOS': { 
		  $pkg='httpd' 
		  $svc='httpd'
		  $cfg_dir="/etc/httpd/conf.d"
		}
  }
  
  package { $pkg: ensure => present, }

   service { $svc:
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      enable => true,
      require => Package["${pkg}"],
   }
}