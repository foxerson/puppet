class apache { 
  # deploys k5start init scripts and Apache running inside PAG.
  
  # define relationship and ordering (> 2.6.0)
  # Package['apache', 'kstart'] -> File['k5start','svc_keytab','pag_init', 'k5start_defaults'] ~> Service['pag']
  
  # Installation
  # k5start
  package { 'kstart': ensure => present, }
  
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
    alias => apache,
    notify => Service["$apache_svc"],
  }
 
  # Apache service must be managed by pag service
  service { "$apache_svc":
    ensure  => stopped,
    hasstatus => true,
    hasrestart => true,
    enable => false,
  }
  
  # Service pag is the one that should start/stop k5start+apache
  service { "pag":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => [Package['apache', 'kstart'], File["/etc/init.d/pag"]],
  }
 
  file { "/etc/init.d/k5start":
    alias => k5start,
    source => $operatingsystem ? {
      "ubuntu"  => 'puppet:///modules/apache/k5start.sh',
      "redhat"  => 'puppet:///modules/apache/k5start_rh.sh',
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
    source => 'puppet:///modules/apache/k5start',
    ensure => "present",
    mode => 644,
    owner => root,
    group => root,
    require => Package["kstart"],
  }
 
  # service principal service/lbrewww 
  file { "/etc/lbrewww.keytab":
    alias => svc_keytab,
    source => "puppet:///modules/apache/lbrewww.keytab",
    ensure => present,
    mode => 600,
    owner => root,
    group => root,
  }

  # prepare the service principal service/lbrewww 
  file { "/etc/init.d/pag":
    source => "puppet:///modules/apache/pag",
    ensure => present,
    mode => 755,
    owner => root,
    group => root,  
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
   
   # needed to reload Apache
   exec { "pag_force_restart":
      command => "/etc/init.d/pag restart",
   }
}
