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

   # Apache runs on inside pag. Thus it will be started by pag wrapper init script
   service { 'apache':
      name => $svc
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      enable => false,
      require => Package["${pkg}"],
   }
}
