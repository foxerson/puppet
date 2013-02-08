# Ensures mysql-server is configured as a master
# NOTE: Ubuntu hosts ***ONLY***

# A master mysql-server. What does that mean ?
#
# - Networking is enabled and bound to
# - Server has an ID different than 0 (otherwise it cannot be the master)
# - There is an user that is able to perform replication (GRANT REPLICATION), so that the slave can bind to it
# - This script also changes the root password (inherits from a config class)

class mysqlserver::config-master inherits mysqlserver::config {
	file { "mysqlserver-test":
		path => '/tmp/a'
		ensure => file,
	}
}
