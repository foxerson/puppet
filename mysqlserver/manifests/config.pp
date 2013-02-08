# Ensures mysql-server is configured (base)
# NOTE: Ubuntu hosts ***ONLY***

# This script changes the root password, and serves as base for other configuration scripts (master and slave)

# It takes 2 password parameters: an old password and a new one. This script can be used to update passwords as well.
# If you set the new pass to UNSET, it will not do anything and just silently pass...

class mysqlserver::config {
	$old_root_pw = ''
	$root_pw     = 'Wh@teveR'

	if $root_pw != 'UNSET' {
		case $old_root_pw {
			'':      { $old_pw='' }
			default: { $old_pw="-p'$old_root_pw'" }
		}

		exec { 'set_mysql_rootpw':
			command   => "mysqladmin -u root ${old_pw} password '${root_pw}' flush-privileges",
			logoutput => true,
			unless    => "mysqladmin -u root -p'${root_pw}' status > /dev/null",
			path      => '/sbin:/usr/sbin:/usr/bin:/bin',
		}
	}
}
