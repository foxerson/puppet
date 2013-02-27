class pag {
  # deploys k5start init scripts and Apache running inside PAG.
  
  # k5start
  package { 'kstart': ensure => present, }
 
  file { "/etc/init.d/k5start":
    source => $operatingsystem ? {
      "ubuntu"  => 'puppet:///modules/pag/k5start.sh',
      "redhat"  => 'puppet:///modules/pag/k5start_rh.sh',
    },
    ensure => "present",
    mode => 755,
    owner => root,
    group => root,
    require => Package["kstart"],
  }
 
  file { 'k5start_defaults':
    path => $operatingsystem ? {
      'ubuntu' => '/etc/default/k5start',
      'redhat' => '/etc/sysconfig/k5start',
    },
    source => 'puppet:///modules/pag/k5start',
    ensure => "present",
    mode => 644,
    owner => root,
    group => root,
    require => Package["kstart"],
  }
 
  # service principal service/lbrewww 
  file { "/etc/lbrewww.keytab":
    source => "puppet:///modules/pag/lbrewww.keytab",
    ensure => present,
    mode => 600,
    owner => root,
    group => root,
  }
   
  # apache
  case $operatingsystem {
 		'Ubuntu','Debian': { 
 		  $apache_pkg='apache2'
 		  $apache_svc='apache2'
 		}
 		'RedHat', 'CentOS': { 
 		  $apache_pkg='httpd' 
 		  $apache_svc='httpd'
 		}
   }

  package { "$apache_pkg": 
    ensure => present,
    notify => Service["$apache_svc"],
  }
  
  # Apache service must be disabled. Pag will start it when called.
  service { "$apache_svc":
    ensure => stopped,
    hasrestart => true,
    hasstatus => true,
    enable => false,
    require => Package["$apache_pkg"],
  }
  
  # PAG

  # prepare the service principal service/lbrewww 
  file { "/etc/init.d/pag":
    source => "puppet:///modules/pag/pag",
    ensure => present,
    mode => 755,
    owner => root,
    group => root,  
  }

  # The pag script will be used as service, but it will be managed by the OS
  # The reason for this is that pag is just a wrapper script that does not need
  # to be checked for its state
  service { "pag":
      ensure      => running,
      hasstatus   => true,
      hasrestart  => true,
      enable      => true,
      require     => Package["kstart", "$apache_svc"],
      subscribe   => File["/etc/init.d/pag", "/etc/init.d/k5start", "k5start_defaults", "/etc/lbrewww.keytab"],
  }

  # install PAG service init. Has dependency on openafs client (25 20). 
  # MUST run after openafs-client shutdown earlier. Ubuntu, for some reason, 
  # is not respecting the LSB header. Therefore, force it manually.
   exec { "update-rc":
      path        => "/bin:/sbin:/usr/bin:/usr/sbin",
      command     => "/usr/sbin/update-rc.d pag defaults 26 21",
      subscribe   => File['/etc/init.d/pag'],
      onlyif      => "grep -i ubuntu /etc/lsb-release",
      refreshonly => true,
   }
   
   exec { "pag_force_restart":
     command => "/etc/init.d/pag restart",
   }
}
