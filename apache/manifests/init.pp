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
  
  package { $pkg: 
    ensure => present,
    notify =>    $operatingsystem ? {
        "ubuntu"  => Exec["update-rc-apache"],
        "redhat"  => Exec["chkconfig-apache"],
    },
    require => Class["pag"],
  }

  # as Apache with afs support runs inside a pag, it must be disabled and 
  # only runs via pag init script.
   exec { "update-rc-apache":
      path        => "/bin:/sbin:/usr/bin:/usr/sbin",
      command     => "/usr/sbin/update-rc.d apache2 disable",
      onlyif      => "grep -i ubuntu /etc/lsb-release",
      refreshonly => true,
  }
  
  exec { "chkconfig-apache":
         path        => "/bin:/sbin:/usr/bin:/usr/sbin",
         command     => "/sbin/chkconfig httpd off",
         onlyif      => "test -f /etc/redhat-release",
         refreshonly => true,
  }

  # Apache runs on inside pag. Thus it will be started by pag wrapper init script
  # service { 'apache':
  #      ensure => running,
  #      hasstatus => true,
  #      hasrestart => true,
  #      enable => false,
  #      require => [Package["${pkg}"],Class["pag"]],
  #   }
  
}
