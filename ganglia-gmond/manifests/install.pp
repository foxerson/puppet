class ganglia-gmond::install {
  package { "${ganglia-gmond::params::pkg}":
    ensure=> present,
  }
}