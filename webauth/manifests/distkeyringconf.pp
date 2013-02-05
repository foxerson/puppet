#
# Distribute the dist-keyring configuration

define webauth::distkeyringconf(
    $ensure           = 'present',
    $keyringmaster,
    $keyringreplicas,
    $keyringpath      = '/var/lib/webauth'
) {
    file { "$name":
        ensure  => $ensure,
        content => template('webauth/dist-keyring.conf.erb'),
    }
} 
