# it must be added to the node definition when 
# creating/modifying an Apache virtual host entry
# each host can have as many as necessary

# Virtual Host definition for basic website, either using SSL or not.
define apache::vhost($ip, $docroot, $ssl=true, $template='apache/vhost.conf.erb',
$priority, $serveraliases= '', $logdir='/var/log/apache') {
  include apache
  
  file { "$apache::params::cfg_dir/${priority}-${name}": 
    content => template($template),
    owner => root,
    group => root,
    mode => 777,
    require => Class["apache::install"],
  }
}

# virtual host definition for vanity URL
define apache::vhost_redir($ip, $ssl=false, $dest_url, $template='apache/vhost_redirect.conf.erb',
$priority, $serveraliases= '', $logdir='/var/log/apache') {
  include apache
  
  file { "$apache::params::cfg_dir/${priority}-${name}": 
    content => template($template),
    owner => root,
    group => root,
    mode => 777,
    require => Class["apache::install"],
  }
}