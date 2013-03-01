class apache { 
  # deploys k5start init scripts and Apache running inside PAG.
  
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
    # notify => Exec[apache_disable],
  }
  
  exec { "apache_disable":
    path  => "/bin:/sbin:/usr/bin:/usr/sbin",
    command => $operatingsystem ? {
      "ubuntu" => "update-rc.d apache2 disable",
      "redhat" => "chkconfig httpd off",
    },
    subscribe => Package[package],
    refreshonly => true,
  }
  
  # Service pag is the one that should start/stop k5start+apache
  service { "pag":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => [ Class['openafs::install'], Package['apache','kstart'], File['k5start_init','pag_init'] ],
  }
  
  # prepare the service principal service/lbrewww 
  file { "/etc/init.d/pag":
     alias => pag_init,
     source => "puppet:///modules/apache/pag",
     ensure => present,
     mode => 755,
     owner => root,
     group => root,
     notify => Service[pag],
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
   
  file { "/etc/init.d/k5start":
    alias => k5start_init,
    source => $operatingsystem ? {
      "ubuntu"  => 'puppet:///modules/apache/k5start.sh',
      "redhat"  => 'puppet:///modules/apache/k5start_rh.sh',
    },
    ensure => "present",
    mode => 755,
    owner => root,
    group => root,
    require => [Package[kstart], File['k5start_defaults', 'svc_keytab']],
    notify => Service[pag],
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
    notify => Service[pag],
  }
 
  # service principal service/lbrewww 
  file { "/etc/lbrewww.keytab":
    alias => svc_keytab,
    source => "puppet:///modules/apache/lbrewww.keytab",
    ensure => present,
    mode => 600,
    owner => root,
    group => root,
    require => Package["kstart"],
    notify => Service[pag],
  }

}
