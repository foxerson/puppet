# A WebAuth client.  Note that this probably won't make sense to include on a
# host that doesn't also include the apache module.

class webauth {  
  package { 'stanford-webauth': 
    ensure => present,
   }

  # On Debian squeeze, prefer the version from backports.
  if ($lsbdistcodename == 'squeeze') {
    file { '/etc/apt/preferences.d/webauth':
      source => 'puppet:///modules/webauth/etc/apt/preferences.d/webauth',
      before => Package['stanford-webauth'],
    }
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
    require => Package['stanford-webauth'],
  }
}
