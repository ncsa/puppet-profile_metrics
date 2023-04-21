# @summary Configure metrics grafana services
#
# @param db_name
#   Name of MySQL database used by grafana
#
# @param db_passwd
#   Password of MySQL database user for grafana
#
# @param db_user
#   Username of MySQL database user for grafana
#
# @example
#   include profile_metrics_alerting
class profile_metrics_alerting (
  String $db_name,
  String $db_passwd,
  String $db_user,
) {
  # HTTPD PROXY
  include profile_website

  # MARIADB SERVICE
  include profile_mysql_server

  # GRAFANA SERVICE
  include grafana

  include profile_metrics_alerting::alert_cycle
  include profile_metrics_alerting::ssh
  include profile_metrics_alerting::tools
}
