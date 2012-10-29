class ganglia-gmetad::install {
  package { $ganglia-gmetad::params::pkg:
    ensure=> present,
  }
}