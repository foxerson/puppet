#
# This class just installs the wallet package, making sure we don't try
# install it on rhel3 and sarge which we can't support it.
#
# Maybe eventually it should support wallet::server, etc.

class wallet::client {
  
  # will be used to set up repositories before 
  # installing wallet-client and stanford-webaut
  stage { 'reposetup': }
  Stage['reposetup'] -> Stage['main']  
  
  case $lsbdistrelease {
        "3": { 
            package { "wallet-client": ensure => absent }
        }
        default: {
            package {
                "wallet-client": ensure => $lsbdistcodename ? {
                        sarge   => purged,
                        default => present,
                        require => File["/etc/apt/sources.list.d/stanford.list"]
                    }
            }
        }
  }  
  package { "kstart": ensure => present }
}

