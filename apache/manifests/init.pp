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

   # prepare the service/lbrewww keytab in case afs will server pages
   file { "/etc/lbrewww.keytab":
     source => "puppet:///modules/apache/lbrewww.keytab",
     ensure => present,
     mode => 600,
     owner => root,
     group => root,  
   }

   service { $svc:
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      enable => true,
      require => Package["${pkg}"],
   }
}