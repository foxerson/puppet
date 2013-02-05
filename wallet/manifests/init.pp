#
# Download objects via the wallet.  It assumes that proper settings have been
# put in /etc/krb5.conf and the ACLs on the objects are set up appropriately.
#
# Examples:
#
#     # Create primary keytab file (default is primary)
#     wallet { "service/adroit-gerbil": 
#         path    => "/etc/adroit/gerbil.keytab",
#         owner   => "leroy",
#         primary => true,
#         ensure  => present,
#     }
# 
#     # Add another keytab to the above primary keytab
#     wallet { "service/adroit-gerbil-another": 
#         path    => "/etc/adroit/gerbil.keytab",
#         primary => false,
#         require => Wallet["service/adroit-gerbil"],
#         ensure  => present,
#     }
# 
#     # Remove the keytab file
#     wallet { "service/funky-chicken": 
#         path   => "/etc/funky/chicken.keytab",
#         ensure => absent,
#     }
#
#     # Download a password file.
#     wallet { "unix-foobar-db-baz":
#         path => "/etc/foobar/password",
#         type => "file",
#     }

# These helper routines are broken out separately to reduce indentation, but
# shouldn't be called separately.  They're purely an implementation detail.

# will be used to set up repositories before 
# installing wallet-client and stanford-webaut
stage { 'aptrepos': before => Stage['main'] }

define wallet::keytab(
    $kstart_cmd,
    $path,
    $primary = true,
    $mode    = 600,
    $owner   = "root",
    $group   = "root",
    $heimdal = false
) {
    $wallet_opts = "-f '$path' get keytab '$name'" 
    exec { "wallet $wallet_opts":
        path    => "/bin:/usr/bin:/usr/local/bin:/usr/kerberos/bin",
        command => "${kstart_cmd} wallet ${wallet_opts}",
        unless  => $heimdal ? {
            true  => "/usr/sbin/ktutil -k '$path' list | grep -i -q '$name'",
            false => "klist -k '$path' | grep -i -q '$name'",
        },
        require => [ Package["kstart"], Package["wallet-client"] ],
    }
    case $primary {
        true, "true": {
            file { "$path":
                mode    => $mode,
                owner   => $owner,
                group   => $group,
                require => Exec["wallet $wallet_opts"],
            }
        }
        false, "false": { }
        default: {
            crit "Invalid value for primary: $primary (not true or false)"
        }
    }
}

define wallet::other(
    $kstart_cmd,
    $path,
    $type,
    $mode   = 600,
    $owner  = "root",
    $group  = "root",
    $onlyif = "NONE"
) {
    $wallet_opts = "-f '$path' get '$type' '$name'"
    case $onlyif {
        "NONE": {
            exec { "wallet $wallet_opts":
                path    => "/bin:/usr/bin:/usr/local/bin:/usr/kerberos/bin",
                command => "${kstart_cmd} wallet ${wallet_opts}",
                creates => $path,
                require => [ Package["kstart"], Package["wallet-client"] ],
            }
        }
        default: {
            exec { "wallet $wallet_opts":
                path    => "/bin:/usr/bin:/usr/local/bin:/usr/kerberos/bin",
                command => "${kstart_cmd} wallet ${wallet_opts}",
                onlyif  => $onlyif,
                require => [ Package["kstart"], Package["wallet-client"] ],
            }
        }
    }
    file { "$path":
        mode    => $mode,
        owner   => $owner,
        group   => $group,
        require => Exec["wallet $wallet_opts"],
    }
}

define wallet(
    $auth_keytab    = "/etc/krb5.keytab",
    $auth_principal = "NA",
    $ensure         = "present",
    $owner          = "root",
    $group          = "root",
    $mode           = 600,
    $path,
    $primary        = "true",
    $type           = "keytab",
    $onlyif         = "NONE",
    $heimdal        = false
) {
    case $auth_principal {
        "NA": { 
            $kstart_cmd = "k5start -Uqf '$auth_keytab' --" 
        }
        default: { 
            $kstart_cmd = "k5start -qf '$auth_keytab' '$auth_principal' --" 
        }
    }

    case $ensure {
        "absent": {
            file { "$path": ensure => absent }
        }
        "present": {
            case $type {
                "keytab": {
                    wallet::keytab { "$name":
                        kstart_cmd => $kstart_cmd,
                        path       => $path,
                        primary    => $primary,
                        mode       => $mode,
                        owner      => $owner,
                        group      => $group,
                        heimdal    => $heimdal,
                    }
                }
                default: {
                    wallet::other { "$name":
                        kstart_cmd => $kstart_cmd,
                        path       => $path,
                        type       => $type,
                        mode       => $mode,
                        owner      => $owner,
                        group      => $group,
                        onlyif     => $onlyif,
                    }
                }
            }
        }
    }
}
