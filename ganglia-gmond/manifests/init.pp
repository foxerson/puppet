# installs and configure ganglia gmond on Ubuntu and red hat servers
class ganglia-gmond {
  include ganglia-gmond::params, ganglia-gmond::install, ganglia-gmond::config, ganglia-gmond::service
}