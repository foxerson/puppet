class krb5::install {
	package { $krb5::params::krb5_pkg_name:
		ensure => installed,
	}	
}