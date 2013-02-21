class pag {
  # this class deploys k5start init scripts to run 
  # PAG-free AFS token that k5start obtains.
  
  package { 'kstart': ensure => present, }
  
  service { "k5start":
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => [Package["kstart"], File["/etc/init.d/k5start"]],
    subscribe   => File["/etc/init.d/k5start"],
  }

  file { "/etc/init.d/k5start":
    source => $operatingsystem ? {
      "ubuntu"  => puppet:///modules/pag/k5start.sh,
      "redhat"  => puppet:///modules/pag/k5start_rh.sh,
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
    source => puppet:///modules/pag/k5start,
    ensure => "present",
    mode => 644,
    owner => root,
    group => root,
    require => Package["kstart"],
  }
  
  # prepare the service principal service/lbrewww 
  file { "/etc/lbrewww.keytab":
    source => "puppet:///modules/pag/lbrewww.keytab",
    ensure => present,
    mode => 600,
    owner => root,
    group => root,
  }
  
  exec { "update-rc":
    command     => "/usr/sbin/update-rc.d defaults 26 21",
    subscribe   => File['/etc/init.d/k5start'],
    onlyif      => "grep -i ubuntu /etc/lsb-release",
    refreshonly => true,
  }

  exec { "chkconfig":
    command     => "/sbin/chkconfig --add k5start",
    subscribe   => File['/etc/init.d/k5start'],
    onlyif      => "test -f /etc/redhat-release",
    refreshonly => true,
  } 
}
