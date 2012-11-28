class pam::params {
	case $operatingsystem {
		/(Ubuntu|Debian)/: {
			$pam = "libpam-krb5"
			$pam_afs = 'libpam-afs-session'
			$pam_ldap = 'libpam-ldap'
		}
		
		/(RedHat|Centos|Fedora)/: {
			$pam = "pam_krb5"
			$pam_afs = 'pam-afs-session'
      if $operatingsystemrelease >= 6 {
        $pam_ldap = 'pam_ldap'
      } else {
        $pam_ldap = 'nss_ldap'
      }
    }
	}
}
