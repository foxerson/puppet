# A WebAuth client.  Note that this probably won't make sense to include on a
# host that doesn't also include the apache module.

class webauth {
  
 	case $operatingsystem {
		'Ubuntu','Debian': { 
		  $pkg='libapache2-webauth'
		  $cfg_dir="/etc/apache2/conf.d"
		  $cfg="$cfg_dir/stanford-webauth"		  
		  }
		'RedHat', 'CentOS': { 
		  $pkg='webauth' 
		  $cfg_dir="/etc/httpd/conf.d"
		  $cfg="$cfg_dir/stanford-webauth.conf"
		  }
	}
	
  file { $cfg_dir: ensure => directory }
  package { $pkg: 
    ensure => present,
    require => Class["apache"],
   }

  # On Debian squeeze, prefer the version from backports.
  if ($lsbdistcodename == 'squeeze') {
    file { '/etc/apt/preferences.d/webauth':
      source => 'puppet:///modules/webauth/etc/apt/preferences.d/webauth',
      before => Package["${pkg}"],
    }
  }
  
  # dont use stanford-webauth packages.
  file { $cfg:
    source => 'puppet:///modules/webauth/webauth.conf',
    ensure => present,
    before => Package["${pkg}"],
  }
    
  # Automate the keytab installation.
  file { '/etc/webauth': ensure => directory }
  wallet { "webauth/${fqdn}":
    path    => '/etc/webauth/keytab',
    mode    => '0640',
    owner   => 'root',
    group   => $operatingsystem ? {
            'redhat' => 'apache',
            default  => 'www-data', 
        },
    require => Package["${pkg}"],
  }
}
