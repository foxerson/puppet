class krb5::config {
	file { "/etc/krb5.conf":
		ensure => present,
		owner => "root",
		group => "root",
		mode => 0644,
		source => "puppet:///modules/krb5/krb5.conf",
		require => Class["krb5::install"],
	}
}