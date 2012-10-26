# installs and configure ganglia gmetad on Ubuntu and red hat servers
class ganglia-gmetad {
  include ganglia-gmetad::params, ganglia-gmetad::install, ganglia-gmetad::service
}