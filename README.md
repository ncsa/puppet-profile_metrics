# profile_metrics_alerting

![pdk-validate](https://github.com/ncsa/puppet-profile_metrics_alerting/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_metrics_alerting/workflows/yamllint/badge.svg)

NCSA Common Puppet Profiles - configure metrics grafana services

This installs and configures Grafana for ICI monitoring:
- [ICI Monitoring](https://wiki.ncsa.illinois.edu/display/IM/ICI+Central+Grafana+Documentation)
- [Service Document](https://wiki.ncsa.illinois.edu/display/ICI/Metrics+Grafana+for+ICI+Monitoring)


## Usage

To install and configure:

```puppet
include profile_metrics_alerting
```

## Configuration

The following parameters need to be set in hiera:
```yaml
profile_metrics_alerting::db_passwd: "PASSWORD"  # PREFERABLY ENCRYPTED
```

:warning:
The following parameters are no longer supported: 
`cilogon_client_id`, `cilogon_client_secret`, `grafana_server_root_url`, & `grafana_version`. 
All Grafana parameters are now expected to be configured via hiera, etc.

Additional hiera data for Grafana & MySQL also need to be set. Below is sample hiera data for these:
```yaml
grafana::cfg:
  alerting:
    enabled: true
  analytics:
    reporting: true
  app_mode: "production"
  auth:
    login_maximum_inactive_lifetime_duration: "9h"
    login_maximum_lifetime_duration: "7d"
    disable_login_form: true
    disable_signout_menu: true
  "auth.anonymous":
    enabled: true
    hide_version: true
    org_name: "NCSA"
    org_role: "Viewer"
  "auth.basic":
    enabled: true
  "auth.generic_oauth":
    allow_assign_grafana_admin: true
    allow_sign_up: true
    api_url: "https://cilogon.org/oauth2/userinfo"
    auth_url: "https://cilogon.org/authorize"
    client_id: "cilogon_client_id"
    client_secret: "cilogon_client_secret"
    enabled: true
    login_attribute_path: "uid"
    name: "NCSA CILogon"
    role_attribute_path: "contains(isMemberOf[*], 'ici_monitoring_admin') && 'Admin' || 'Viewer'"
    scopes: "openid,email,profile,org.cilogon.userinfo"
    token_url: "https://cilogon.org/oauth2/token"
  "auth.ldap":
#    allow_sign_up: true
#    config_file: "/etc/grafana/ldap.toml"
    enabled: false
  database:
    type: "mysql"
    host: "127.0.0.1:3306"
    name: "%{lookup('profile_metrics_alerting::db_name')}"
    password: "%{lookup('profile_metrics_alerting::db_passwd')}"
    user: "%{lookup('profile_metrics_alerting::db_user')}"
  explore:
    enabled: false
  live:
    allowed_origins: "*"
  server:
    http_port: 8080
    root_url: "https://%{facts.fqdn}"
  smtp:
    enabled: true
    from_address: "root@${$facts["fqdn"]}"
    from_name: "${$facts["fqdn"]} Grafana Alerts"
    host: "localhost:25"
    skip_verify: true
  users:
    allow_sign_up: false
    allow_org_create: false
  version: "installed"

grafana::ldap_cfg:
  - servers:
      - host: "ldap1.ncsa.illinois.edu"
        port: 636
        use_ssl: true
        search_filter: "(&(objectClass=inetorgperson)(!(memberOf=cn=all_disabled_usr,ou=groups,dc=ncsa,dc=illinois,dc=edu)))"
        search_base_dns: "['dc=ncsa,dc=illinois,dc=edu']"
        #bind_dn: "ldap-bind@ncsa.illinois.edu"
        #bind_password: "find_in_LastPass"
      - host: "ldap2.ncsa.illinois.edu"
        port: 636
        use_ssl: true
        search_filter: "(&(objectClass=inetorgperson)(!(memberOf=cn=all_disabled_usr,ou=groups,dc=ncsa,dc=illinois,dc=edu)))"
        search_base_dns: "['dc=ncsa,dc=illinois,dc=edu']"
        #bind_dn: "ldap-bind@ncsa.illinois.edu"
        #bind_password: "find_in_LastPass"
    servers.attributes:
      name: "givenName"
      surname: "sn"
      username: "uid"
      member_of: "memberOf"
      email: "mail"
    servers.group_mappings:
      - group_dn: "cn=org_ici,ou=groups,dc=ncsa,dc=illinois,dc=edu"
        org_role: "Viewer"
      - group_dn: "cn=ici_monitoring_admin,ou=groups,dc=ncsa,dc=illinois,dc=edu"
        org_role: "Admin"
        grafana_admin: true

profile_mysql_server::create_mysql_home: false
profile_mysql_server::dbs:
  "%{lookup('profile_metrics_alerting::db_name')}":
    password: "%{lookup('profile_metrics_alerting::db_passwd')}"
    user: "%{lookup('profile_metrics_alerting::db_user')}"
    host: "localhost"
    charset: "utf8mb4"
    collate: "utf8mb4_general_ci"
```

To make use of [grafana_tools](https://github.com/jdmaloney/grafana_tools/) 
you will also want to set the following parameters:
```yaml
profile_metrics_alerting::ssh::metrics_node_ips:
  - "10.0.0.101"
  - "10.0.0.102"
profile_metrics_alerting::ssh::sshkey_priv: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3Blb...AQI=
  -----END OPENSSH PRIVATE KEY-----
profile_metrics_alerting::ssh::sshkey_pub: "\
  AAAAB.....X4US0="
profile_metrics_alerting::ssh::sshkey_type: "rsa"
profile_metrics_alerting::tools::grafana_admin_password: "PASSWORD"
profile_metrics_alerting::tools::ldap_sync_groups:
  - "group_one"
  - "group_two"
  - "etc"
profile_metrics_alerting::tools::ldap_sync_group_search_base: "ou=groups,dc=example,dc=local"
profile_metrics_alerting::tools::ldap_sync_user_search_base: "ou=people,dc=example,dc=local"
profile_metrics_alerting::tools::whitelabel_subtitle: "Managed by ORGANIZATION GROUP"
profile_metrics_alerting::tools::whitelabel_title: "Monitoring and Telemetry Interface"
```

To pause/start alerts on a schedule (applicable for old style alerts only), you can use these parameters:
```yaml
# Format for command is similar to running alert_toggle.sh by hand, see README in files/root/grafana_tools
profile_metrics_alerting::alert_cycle::crons:
   "Pause mforgehn1 alerts":
    command: "pause tag \"mforgehn1\""
    hour: 21
    minute: 55
    weekday: 0
  "Start mforgehn1 alerts":
    command: "start tag \"mforgehn1\""
    hour: 0
    minute: 45
    weekday: 1
profile_metrics_alerting::alert_cycle::enable_cycle_alerts: true
```
You'll want to define your crons for `profile_metrics_alerting::alert_cycle::crons` in any role that uses this repo (For example if you have a primary/secondary role). This is because if you swap roles you want the alert pausing/starting crons to be removed from the secondary role so you don't get alerts enabled in multiple places leading to duplicate alerts. 

## Initial Restoration of Grafana Database

After the initial setup make use of the [grafana_tools](https://github.com/jdmaloney/grafana_tools/) 
[backup_and_sync](https://github.com/jdmaloney/grafana_tools/blob/main/backup_and_sync/README.md) 
scripts to do one of the following:
- restore data from a backup, or
- sync from another Grafana server

## Dependencies

- [ncsa/profile_mysql_server](https://github.com/ncsa/puppet-profile_mysql_server)
- [ncsa/sshd](https://github.com/ncsa/puppet-sshd)
- [puppet/grafana](https://forge.puppet.com/modules/puppet/grafana)
- [puppetlabs/mysql](https://forge.puppet.com/modules/puppetlabs/mysql)

## Reference

[REFERENCE.md](REFERENCE.md)

