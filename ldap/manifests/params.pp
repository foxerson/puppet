class ldap::params {
  case $operatingsystem {
    Ubuntu,Debian: {
      $pkgs = ["ldap-utils","nscd", "tcsh"]
      $dir = "/etc/ldap"
    }
    RedHat,Fedora: {
      if $operatingsystemrelease >= 6 { 
        $pkgs = [ "openldap", "openldap-clients","tcsh", "nscd", "nss-pam-ldapd" ]
      } else {
        $pkgs = ["openldap", "openldap-clients","tcsh", "nscd"]
      }      
      $dir = "/etc/openldap"
    }
  }
}