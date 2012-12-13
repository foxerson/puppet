#
# This class just installs the wallet package, making sure we don't try
# install it on rhel3 and sarge which we can't support it.
#
# Maybe eventually it should support wallet::server, etc.

class wallet::client {
  
  if $operatingsystem == "Ubuntu" or $operatingsystem =="debian" {
      # Required for wallet-client
      file { "/etc/apt/sources.list.d/stanford.list":
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0644,
        content => "deb http://debian.stanford.edu/debian-stanford stable main",
        notify => File["/etc/apt/sources.list.d/stanford.list"],	  
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
  
  case $lsbdistrelease {
        "3": { 
            package { "wallet-client": ensure => absent }
        }
        default: {
            package {
                "wallet-client": ensure => $lsbdistcodename ? {
                        sarge   => purged,
                        default => present,
                    }
            }
        }
  }  
  package { "kstart": ensure => present }
}

