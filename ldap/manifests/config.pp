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
  
  # for either one.
  file { "${ldap::params::dir}/ldap.conf":
		source => "puppet:///modules/ldap/etc_ldap_ldap.conf",
  }

  file { "/etc/nsswitch.conf":
       source => "puppet:///modules/ldap/nsswitch.conf",
  }

  case $operatingsystem {
    RedHat, Fedora: {
      if $operatingsystemrelease >= 6 {
        include ldap::service
        
        file { "/etc/nslcd.conf":
          source => "puppet:///modules/ldap/nslcd.conf",
          notify => Class["ldap::service"],
        }
      }
      
      file { "/etc/pam_ldap.conf": 
        source => "puppet:///modules/ldap/pam_ldap.conf",
      }
    }  
  }
    
  
}