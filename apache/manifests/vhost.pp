# it must be added to the node definition when 
# creating/modifying an Apache virtual host entry
# each host can have as many as necessary

define apache::vhost($ip, $port, $docroot, $ssl=true, $template='apache/vhost.conf.erb',
$priority, $serveraliases= '', $logdir='/var/log/apache') {
  include apache
  
  file { "$apache::params::cfg_dir/${priority}-${name}": 
    content => template($template)
    owner => root,
    group => root,
    mode => 777,
    require => Class["apache::install"],
  }
}