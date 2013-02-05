class pam::install {
	package { $pam::params::pam:
		ensure => present,
	}
	
	package { $pam::params::pam_afs:
   ensure => present,
	}
	
	package { $pam::params::pam_ldap:
   ensure => present,
	}
	
}