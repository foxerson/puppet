class ldap::config {
  File {
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    require => Class["ldap::install"],
    notify => Class["ldap::service"],
  }
  
  # for both OSes
  file { "/etc/ldap.conf":
		source => "puppet:///modules/ldap/etc_ldap.conf",
  }
  
  file { "${ldap::params::dir}/ldap.conf":
		source => "puppet:///modules/ldap/etc_ldap_ldap.conf",
  }

  file { "/etc/nsswitch.conf":
       source => "puppet:///modules/ldap/nsswitch.conf",
  }

  file { "/etc/nslcd.conf":
     source => "puppet:///modules/ldap/nslcd.conf",
  }
      
  file { "/etc/pam_ldap.conf": 
     source => "puppet:///modules/ldap/pam_ldap.conf",
  }
}