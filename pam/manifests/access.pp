define pam::access($allow) {  
  include pam
  
  # pam_access module will drop the access.conf regardless the OS.
  file { "/etc/security/access.conf":
    content => template('pam/access.conf.erb'),
    owner => 'root',
    group => 'root',
    mode => '644',
    require => Class["pam::install"],
  }  
}