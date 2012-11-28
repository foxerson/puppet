class krb5::params {
	case $operatingsystem {
		/(Ubuntu|Debian)/: {
			$krb5_pkg_name = ["krb5-user","krb5-clients"]
		}
		/(RedHat|Centos|Fedora)/: {
			$krb5_pkg_name = 'krb5-workstation'
		}
	}
}