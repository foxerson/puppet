# mysql-server service
# NOTE: Ubuntu hosts ***ONLY***

class mysqlserver::service {
	service { "mysql":
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		enable => true,
		require => Class["mysqlserver::install"],
	}
}
