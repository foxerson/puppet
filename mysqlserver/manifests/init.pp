# installs and configure mysql server on Ubuntu hosts
# NOTE: Ubuntu hosts ***ONLY***

class mysqlserver-master {
	include mysqlserver::install, mysqlserver::service, mysqlserver::config-master
}

class mysqlserver-slave {
	include mysqlserver::install, mysqlserver::service, mysqlserver::config-slave
}
