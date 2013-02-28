# it must be added to the node definition when 
# creating/modifying an Apache virtual host entry
# each host can have as many as necessary

# Virtual Host definition for basic website, either using SSL or not.
define apache::vhost($ip, $docroot, $ssl=true, $template='apache/vhost.conf.erb',
$priority, $serveraliases= '', $logdir='/var/log/apache') {
  include apache
  
  case $operatingsystem {
  		'Ubuntu','Debian': { 
  		  $apache_conf_dir = "/etc/apache2/conf.d"
  		  $apache_log_dir = "/var/log/apache"
  		}
  		'RedHat', 'CentOS': { 
  		  $apache_conf_dir = "/etc/httpd/conf.d"
  		  $apache_log_dir = "/var/log/httpd"
  		}
  }
  
  file { "$apache_conf_dir/${priority}-${name}":
    path => $operatingsystem ? {
      "ubuntu" => "$apache_conf_dir/${priority}-${name}",
      "redhat" => "$apache_conf_dir/${priority}-${name}.conf",
    },
    content => template($template),
    owner => root,
    group => root,
    mode => 777,
    require => Package[apache],
    notify => Exec["pag_force_restart"],
  }
}

# virtual host definition for vanity URL
define apache::vhost_redir($ip, $ssl=false, $dest_url, $template='apache/vhost_redirect.conf.erb',
$priority, $serveraliases= '', $logdir='/var/log/apache') {
  include apache
  
  $apache_conf_dir = $operatingsystem ? {
    ubuntu => "/etc/apache2/conf.d",
    redhat => "/etc/httpd/conf.d",
  }
  
  file { "$apache_conf_dir/${priority}-${name}": 
    content => template($template),
    owner => root,
    group => root,
    mode => 777,
    require => Package[apache],
    notify => Exec["pag_force_restart"],
  }
}

# generating a configuration with multiple locations and webauth
# Sample call:
# apache::vhost_proxy { 'lbre-basemap.stanford.edu':
#   ip => '171.64.144.200',
#   serveraliases => ['lbre-basemap', 'basemap'],
#   locations => [
#                   ["Location /mapguide2011", "ProxyPass http://localhost", "ProxyPassRev http://localhost2"], 
#                   ["Location /mapguide2012", "ProxyPass http://localhost", "ProxyPassRev http://localhostw"]
#                 ]
# }

# define apache::vhost_proxy($ip, $serveraliases, $template='apache/vhost_custom_block.conf.erb', $custom_block='') {
#   include apache, pag
#   
#   file { "$apache::cfg_dir/${priority}-${name}": 
#     content => template($template),
#     owner => root,
#     group => root,
#     mode => 777,
#     require => Class["apache"],
#   }
#}