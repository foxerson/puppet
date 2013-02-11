# Ensures mysql-server package is installed.
# NOTE: Ubuntu hosts ***ONLY***

class mysqlserver::install {
	package { "mysql-server":
		ensure => present,
		require => User["mysql"],
	}

	user { "mysql":
		ensure => present,
		comment => "MySQL Server",
		gid => "mysql",
		shell => "/bin/false",
		require => Group["mysql"],
	}

	group { "mysql":
		ensure => present,
	}
}
