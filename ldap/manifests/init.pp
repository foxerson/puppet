class ldap {
	# installs ldap client on Ubuntu or RedHat.
	include ldap::params, ldap::install, ldap::config, ldap::service
}