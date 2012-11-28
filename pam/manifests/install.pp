class pam::install {
	package { $pam::params::pam:
		ensure => installed,
	}
	
	package { $pam::params::pam_afs:
   ensure => installed,
	}
	
	package { $pam::params::pam_ldap:
   ensure => installed,
	}
	
}