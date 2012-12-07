define haproxy::config ($port=8080, $addr, $backends, $template='haproxy/haproxy.conf.erb',
$cookie=false, $checksvr=true) {
  
  include haproxy

  $haproxy_cfg_dir = "/etc/haproxy"
  $cfg_path = "${haproxy_cfg_dir}/${name}.cfg"

  file { $haproxy_cfg_dir:
    ensure => directory,
    mode => 0755,
    owner => "root",
    group => "root",  
  }

  file { $cfg_path:
    ensure => present,
    content => template($template),
    require => Package['haproxy'],
    owner => 'root',
    group => 'root',
    mode => '0440',
    notify => Service["haproxy"]
  }
  
  service { "haproxy":
    binary => $operatingsystem ? {
      /(ubuntu|debian)/ => "/usr/sbin/haproxy",
      "redhat" => "/usr/sbin/haproxy",
      default => "/usr/sbin/haproxy", 
    },
    start => "/usr/sbin/haproxy -D -f ${cfg_path}",
    stop => "/bin/kill -SIGUSR1 `pgrep -f ${name}.cfg`",
    restart => "/bin/kill -SIGTTIN `pgrep -f ${name}.cfg`",
    hasstatus => false,
    status => "/usr/bin/pgrep -f ${name}.cfg",
    hasrestart => false,
    loglevel => debug
  }
  
  # exec { "restart haproxy":
  #   command => 'sh -c "killall -1 `pgrep -f ${name}.cfg`"',
  #   subscribe => File["${name}.cfg"],
  #   refreshonly => true,
  #   logoutput => true,
  # }
}