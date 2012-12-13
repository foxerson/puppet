# A WebAuth client.  Note that this probably won't make sense to include on a
# host that doesn't also include the apache module.

class webauth {
  
  if $operatingsystem == "Ubuntu" or $operatingsystem =="debian" {
      # Required for wallet-client
      file { "/etc/apt/sources.list.d/stanford.list":
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0644,
        content => "deb http://debian.stanford.edu/debian-stanford stable main",
        notify => File["/etc/apt/apt.conf.d/99auth"],	  
      }
  
      # It's OK to install unsigned packages
      file { "/etc/apt/apt.conf.d/99auth":       
         owner     => root,
         group     => root,
         content   => "APT::Get::AllowUnauthenticated yes;",
         mode      => 644,
         notify => Exec["aptitude update"],
      }
  
      exec { "aptitude update":
        path => "/usr/bin",
        command => "aptitude update",
      }
  }
  
  # CHANGEME: down the road, create a repository modules for all the packages.
  package { 'stanford-webauth': 
    ensure => present,
    require => File["/etc/apt/sources.list.d/stanford.list"],
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
    require => [Package['stanford-webauth']],
  }
}
