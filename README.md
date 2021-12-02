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
profile_metrics_alerting::cilogon_client_id: "cilogon:/client_id/UNIQUEID"
profile_metrics_alerting::cilogon_client_secret: "SECRETKEY"
profile_metrics_alerting::db_passwd: "PASSWORD"
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

- [ncsa/sshd](https://github.com/ncsa/puppet-sshd)
- [puppet/grafana](https://forge.puppet.com/modules/puppet/grafana)
- [puppetlabs/mysql](https://forge.puppet.com/modules/puppetlabs/mysql)

## Reference

### class profile_metrics_alerting::ssh (
-  Array[String] $metrics_node_ips,
-  String $sshkey_pub,
-  String $sshkey_priv,
-  String $sshkey_type,
### class profile_metrics_alerting::tools (
-  String $backup_and_sync_cron_hour,
-  String $backup_and_sync_cron_minute,
-  String $backup_and_sync_cron_month,
-  String $backup_and_sync_cron_monthday,
-  String $backup_and_sync_cron_weekday,
-  String $backup_and_sync_destination_host,
-  String $backup_and_sync_destination_path,
-  Boolean $backup_and_sync_enable,
-  String $grafana_admin_password,
-  String $grafana_admin_user,
-  String $ldap_sync_base_dir,
-  String $ldap_sync_cron_hour,
-  String $ldap_sync_cron_minute,
-  String $ldap_sync_cron_month,
-  String $ldap_sync_cron_monthday,
-  String $ldap_sync_cron_weekday,
-  Boolean $ldap_sync_enable,
-  Array[String] $ldap_sync_groups,
-  String $whitelabel_subtitle,
-  String $whitelabel_title,
### class profile_metrics_alerting::alert_cycle (
-  Hash $crons,
-  Boolean $enable_cycle_alerts,
-  String $script_path,
### class profile_metrics_alerting (
-  String $cilogon_client_id,
-  String $cilogon_client_secret,
-  String $db_name,
-  String $db_passwd,
-  String $db_user,
-  String $grafana_server_root_url,
-  String $grafana_version,

[REFERENCE.md](REFERENCE.md)

