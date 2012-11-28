class ssh::params {
	case $operatingsystem {
		/(Ubuntu|Debian)/: {
			$ssh_pkg_name = "openssh-server"
			$service_name = "ssh"
      $usepam = "yes" 
      $gssapikeyexchange = "yes"
		}
		/(RedHat|Centos)/: {
			$ssh_pkg_name = "openssh-server"
			$service_name = "sshd"
			if $operatingsystemrelease >= 6 {
			  $gssapikeyexchange = "yes"
			  $usepam = "yes" 
	 		} else { 
			  $usepam = "yes"
			  $gssapikeyexchange = "no"
			}
		}
	}
}