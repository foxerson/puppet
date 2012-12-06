define haproxy::config ($port=8080, $backends, $template='haproxy/haproxy.conf.erb',
$cookie=false, $checksvr=true) {
  
  include haproxy

  file { "${name}.conf":
    content => template($template),
    require => Package['haproxy'],
  } 
}