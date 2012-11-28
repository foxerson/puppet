class openafs {
	# installs openafs client and pam modules on Ubuntu or RedHat.
	include openafs::install, openafs::config, openafs::service
}