# installs and configure mysql server on Ubuntu hosts
# NOTE: Ubuntu hosts ***ONLY***

# To try this localy, use it like this:
#     puppet apply -e "class {'mysqlserver': old_root_pw=>'oldpass', root_pw=>'newpass',}" init.pp --verbose

class mysqlserver ( $old_root_pw='', $root_pw='UNSET', $mode='UNSET' ) {
	include mysqlserver::install, mysqlserver::service

	class {'mysqlserver::config':
		old_root_pw => $old_root_pw,
		root_pw     => $root_pw,
		mode        => $mode,
	}
}
