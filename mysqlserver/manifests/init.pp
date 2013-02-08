# installs and configure mysql server on Ubuntu hosts
# NOTE: Ubuntu hosts ***ONLY***

class mysqlserver ( $old_root_pw='', $root_pw='UNSET', $mode='UNSET' ) {
	include mysqlserver::install, mysqlserver::service

	class {'mysqlserver::config':
		old_root_pw => $old_root_pw,
		root_pw     => $root_pw,
		mode        => $mode,
	}
}
