class pag {
  # this class deploys k5start init scripts to run 
  # PAG-free AFS token that k5start obtains.
  
  package { 'kstart': ensure => present, }
  
  service { "k5start":
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => false,
    require     => [Package["kstart"], File["/etc/init.d/k5start"]],
    subscribe   => File["/etc/init.d/k5start"],
  }

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
  
  # prepare the service principal service/lbrewww 
  file { "/etc/lbrewww.keytab":
    source => "puppet:///modules/pag/lbrewww.keytab",
    ensure => present,
    mode => 600,
    owner => root,
    group => root,
  }

  # prepare the service principal service/lbrewww 
  file { "/etc/init.d/pag":
    source => "puppet:///modules/pag/pag",
    ensure => present,
    mode => 755,
    owner => root,
    group => root,  
  }

  service { "pag":
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => [Package["kstart"], File["/etc/init.d/pag"]],
    subscribe   => File["/etc/init.d/pag"],
  }

  # install PAG service init
  # exec { "update-rc":
  #    path        => "/bin:/sbin:/usr/bin:/usr/sbin",
  #    command     => "/usr/sbin/update-rc.d pag defaults 26 21",
  #    subscribe   => File['/etc/init.d/pag'],
  #    onlyif      => "grep -i ubuntu /etc/lsb-release",
  #    refreshonly => true,
  # }
  # 
  # exec { "chkconfig":
  #    path        => "/bin:/sbin:/usr/bin:/usr/sbin",
  #    command     => "/sbin/chkconfig --add pag",
  #    subscribe   => File['/etc/init.d/pag'],
  #    onlyif      => "test -f /etc/redhat-release",
  #    refreshonly => true,
  # } 
}
