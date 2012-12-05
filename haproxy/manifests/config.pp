# this is how the entry will be, ex:
# listen webfarm 80


# accepted backends format:
# [ "192.168.1.2:80"]
# "192.168.1.2:80","192.168.1.3:8080"
# [ "192.168.1.2:80", 
    "192.168.1.4:8080"]

define haproxy::config ($name, $port=8080, $backends, $template='haproxy/haproxy.conf.erb',
$cookie=false, $check=true) {
  
  include haproxy
  
  file { "${name}":
    name => $operatingsystem ? {
            'debian' => "/etc/haproxy/${cfgfile}",
            'ubuntu' => "/etc/haproxy/${cfgfile}",
            'redhat' => "/etc/haproxy/${cfgfile}",
            },
    source => template($template),
    require => Package['haproxy'],
  } 
}