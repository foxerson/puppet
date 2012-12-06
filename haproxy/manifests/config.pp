define haproxy::config ($port=8080, $addr, $backends, $template='haproxy/haproxy.conf.erb',
$cookie=false, $checksvr=true) {
  
  include haproxy

  file { "/etc/haproxy/${name}.conf":
    content => template($template),
    require => Package['haproxy'],
  } 
}