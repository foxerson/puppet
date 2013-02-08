# Ensures mysql-server is configured
# NOTE: Ubuntu hosts ***ONLY***

# It takes 2 password parameters: an old password and a new one. If the old password is set, it will change it to the new one.
# if the new one is unset, it will do nothing. If the new one is set (and the old one unset), then it just checks the status
# to make sure the new pass is good.
# It also takes a mode parameter. It will configure the server as a master or slave in a replication set

class mysqlserver::config ( $old_root_pw='', $root_pw='UNSET', $mode='UNSET' ) {
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
