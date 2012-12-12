class openafs::install {
  require openafs::params
  include wallet::client
  
  case $operatingsystem {
    RedHat,CentOS,Fedora: {
      # installing
      package { 'openafs-client': ensure => present, }
      package { 'openafs-krb5': ensure => present, }
      package { 'openafs': ensure => present, }
      
      # it seems like kmod-openafs-smp is no longer needed.
      if $processorcount > 1 {
        package { 'kmod-openafs': ensure => present, } 
      } else {
        package { 'kmod-openafs': ensure => present, }
      }
      #package { 'wallet-client': ensure => present, }
    }
    
    Ubuntu,Debian: {
      package { 'openafs-client': ensure => installed, }
      package { 'openafs-krb5': ensure => installed, }
      package { 'openafs-modules-dkms': ensure => installed, }
      # package { 'libpam-afs-session': ensure => installed, }  
      # package { 'remctl-client': ensure => installed, }
      #package { 'wallet-client': ensure => installed, }
    }
  }
}