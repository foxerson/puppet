# installs and configure mysql server on Ubuntu hosts
class mysqlserver {
  include mysqlserver::install, mysqlserver::service
}