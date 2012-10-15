# it must be added to the node definition when 
# creating/modifying an Apache virtual host entry
# each host can have as many as necessary

define apache::vhost($port, $docroot, $ssl=true, $template='apache/vhost.conf.erb',
$priority, $serveraliases= '') {
  include apache
  
  file { $apache::params::cfg_dir: 
    content => template($template)
    owner => root,
    group => root,
    mode => 777,
    require => Class["apache::install"],
  }
    
  
}