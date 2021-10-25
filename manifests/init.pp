# @summary Configure metrics services
#
# @param cilogon_client_id
#   CILogon OIDC client ID
#
# @param cilogon_client_secret
#   CILogon OIDC client secret
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
# @param grafana_server_root_url
#   root_url for grafana server including protocol
#
# @example
#   include profile_metrics
class profile_metrics (
  String $cilogon_client_id,
  String $cilogon_client_secret,
  String $db_name,
  String $db_passwd,
  String $db_user,
  String $grafana_server_root_url,
) {

  # HTTPD PROXY
  include ::profile_website
  # MARIADB SERVICE
  class { 'mysql::server':
    package_name            => 'mariadb-server',
    remove_default_accounts => true,
    restart                 => true,
  }
  mysql::db { $db_name:
    user     => $db_user,
    password => $db_passwd,
    host     => 'localhost',
  }

  # GRAFANA SERVICE
  class { 'grafana':
    cfg => {
      alerting           => {
        enabled => true,
      },
      analytics          => {
        reporting => true,
      },
      auth               => {
        login_maximum_inactive_lifetime_duration => '9h',
        login_maximum_lifetime_duration          => '7d',
        disable_login_form                       => true,
        disable_signout_menu                     => true,
      },
      auth.anonymous     => {
        enabled      => true,
        hide_version => true,
        org_name     => 'NCSA',
        org_role     => 'Viewer',
      },
      auth.basic         => {
        enabled => true,
      },
      auth.ldap          => {
        allow_sign_up => true,
        config_file   => '/etc/grafana/ldap.toml',
        enabled       => false,
      },
      auth.generic_oauth => {
        allow_sign_up        => true,
        api_url              => 'https://test.cilogon.org/oauth2/userinfo',
        auth_url             => 'https://test.cilogon.org/authorize',
        client_id            => $cilogon_client_id,
        client_secret        => $cilogon_client_secret,
        enabled              => true,
        login_attribute_path => 'uid',
        name                 => 'NCSA CILogon',
        role_attribute_path  => 'contains(isMemberOf[*], \'ici_monitoring_admin\') && \'Admin\' || \'Viewer\'',
        scopes               => 'openid,email,profile,org.cilogon.userinfo',
        token_url            => 'https://test.cilogon.org/oauth2/token',
      },
      database           => {
        type     => 'mysql',
        host     => '127.0.0.1:3306',
        name     => $db_name,
        user     => $db_user,
        password => $db_passwd,
      },
      explore            => {
        enabled => false,
      },
      live               => {
        allowed_origins => '*',
      },
      server             => {
        root_url => $grafana_server_root_url,
      },
      smtp               => {
        enabled      => true,
        from_address => 'root@metrics02.ncsa.illinois.edu',
        from_name    => 'NCSA ICI Alert Engine',
        host         => 'localhost:25',
        skip_verify  => true,
      },
      users              => {
        allow_sign_up    => false,
        allow_org_create => false,
      },
    },
  }
  # ANY NCSA CUSTOMIZATION

  include profile_metrics::ssh
}
