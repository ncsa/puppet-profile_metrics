# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`profile_metrics_alerting`](#profile_metrics_alerting): Configure metrics grafana services
* [`profile_metrics_alerting::ssh`](#profile_metrics_alertingssh): Allow ssh between metrics servers
* [`profile_metrics_alerting::tools`](#profile_metrics_alertingtools): Install and configure grafana_tools

## Classes

### <a name="profile_metrics_alerting"></a>`profile_metrics_alerting`

Configure metrics grafana services

#### Examples

##### 

```puppet
include profile_metrics_alerting
```

#### Parameters

The following parameters are available in the `profile_metrics_alerting` class:

* [`cilogon_client_id`](#cilogon_client_id)
* [`cilogon_client_secret`](#cilogon_client_secret)
* [`db_name`](#db_name)
* [`db_passwd`](#db_passwd)
* [`db_user`](#db_user)
* [`grafana_server_root_url`](#grafana_server_root_url)
* [`grafana_version`](#grafana_version)

##### <a name="cilogon_client_id"></a>`cilogon_client_id`

Data type: `String`

CILogon OIDC client ID

##### <a name="cilogon_client_secret"></a>`cilogon_client_secret`

Data type: `String`

CILogon OIDC client secret

##### <a name="db_name"></a>`db_name`

Data type: `String`

Name of MySQL database used by grafana

##### <a name="db_passwd"></a>`db_passwd`

Data type: `String`

Password of MySQL database user for grafana

##### <a name="db_user"></a>`db_user`

Data type: `String`

Username of MySQL database user for grafana

##### <a name="grafana_server_root_url"></a>`grafana_server_root_url`

Data type: `String`

root_url for grafana server including protocol

##### <a name="grafana_version"></a>`grafana_version`

Data type: `String`

optional version of grafana installed

### <a name="profile_metrics_alertingssh"></a>`profile_metrics_alerting::ssh`

Allow ssh between metrics servers

#### Examples

##### 

```puppet
include profile_metrics_alerting::ssh
```

#### Parameters

The following parameters are available in the `profile_metrics_alerting::ssh` class:

* [`metrics_node_ips`](#metrics_node_ips)
* [`sshkey_pub`](#sshkey_pub)
* [`sshkey_priv`](#sshkey_priv)
* [`sshkey_type`](#sshkey_type)

##### <a name="metrics_node_ips"></a>`metrics_node_ips`

Data type: `Array[String]`

List of metrics node ip addresses that need sshd access

##### <a name="sshkey_pub"></a>`sshkey_pub`

Data type: `String`

Public part of root's sshkey.

##### <a name="sshkey_priv"></a>`sshkey_priv`

Data type: `String`

Private part of root's sshkey.

##### <a name="sshkey_type"></a>`sshkey_type`

Data type: `String`

OPTIONAL - defaults to "rsa"

### <a name="profile_metrics_alertingtools"></a>`profile_metrics_alerting::tools`

See https://github.com/jdmaloney/grafana_tools

#### Examples

##### 

```puppet
include profile_metrics_alerting::tools
```

#### Parameters

The following parameters are available in the `profile_metrics_alerting::tools` class:

* [`backup_and_sync_cron_hour`](#backup_and_sync_cron_hour)
* [`backup_and_sync_cron_minute`](#backup_and_sync_cron_minute)
* [`backup_and_sync_cron_month`](#backup_and_sync_cron_month)
* [`backup_and_sync_cron_monthday`](#backup_and_sync_cron_monthday)
* [`backup_and_sync_cron_weekday`](#backup_and_sync_cron_weekday)
* [`backup_and_sync_destination_host`](#backup_and_sync_destination_host)
* [`backup_and_sync_destination_path`](#backup_and_sync_destination_path)
* [`backup_and_sync_enable`](#backup_and_sync_enable)
* [`grafana_admin_password`](#grafana_admin_password)
* [`grafana_admin_user`](#grafana_admin_user)
* [`ldap_sync_base_dir`](#ldap_sync_base_dir)
* [`ldap_sync_cron_hour`](#ldap_sync_cron_hour)
* [`ldap_sync_cron_minute`](#ldap_sync_cron_minute)
* [`ldap_sync_cron_month`](#ldap_sync_cron_month)
* [`ldap_sync_cron_monthday`](#ldap_sync_cron_monthday)
* [`ldap_sync_cron_weekday`](#ldap_sync_cron_weekday)
* [`ldap_sync_enable`](#ldap_sync_enable)
* [`ldap_sync_groups`](#ldap_sync_groups)
* [`whitelabel_subtitle`](#whitelabel_subtitle)
* [`whitelabel_title`](#whitelabel_title)

##### <a name="backup_and_sync_cron_hour"></a>`backup_and_sync_cron_hour`

Data type: `String`

hour that the backup_and_sync cron should run

##### <a name="backup_and_sync_cron_minute"></a>`backup_and_sync_cron_minute`

Data type: `String`

minute that the backup_and_sync cron should run

##### <a name="backup_and_sync_cron_month"></a>`backup_and_sync_cron_month`

Data type: `String`

month that the backup_and_sync cron should run

##### <a name="backup_and_sync_cron_monthday"></a>`backup_and_sync_cron_monthday`

Data type: `String`

monthday that the backup_and_sync cron should run

##### <a name="backup_and_sync_cron_weekday"></a>`backup_and_sync_cron_weekday`

Data type: `String`

weekday that the backup_and_sync cron should run

##### <a name="backup_and_sync_destination_host"></a>`backup_and_sync_destination_host`

Data type: `String`

Host were backups are synced to

##### <a name="backup_and_sync_destination_path"></a>`backup_and_sync_destination_path`

Data type: `String`

Path on destination host where backups are synced to

##### <a name="backup_and_sync_enable"></a>`backup_and_sync_enable`

Data type: `Boolean`

Whether or not backup_and_sync script is automated

##### <a name="grafana_admin_password"></a>`grafana_admin_password`

Data type: `String`

Password of Grafana admin user

##### <a name="grafana_admin_user"></a>`grafana_admin_user`

Data type: `String`

Username of Grafana admin user

##### <a name="ldap_sync_base_dir"></a>`ldap_sync_base_dir`

Data type: `String`

Base directory used by ldap sync

##### <a name="ldap_sync_cron_hour"></a>`ldap_sync_cron_hour`

Data type: `String`

hour that the ldap_sync cron should run

##### <a name="ldap_sync_cron_minute"></a>`ldap_sync_cron_minute`

Data type: `String`

minute that the ldap_sync cron should run

##### <a name="ldap_sync_cron_month"></a>`ldap_sync_cron_month`

Data type: `String`

month that the ldap_sync cron should run

##### <a name="ldap_sync_cron_monthday"></a>`ldap_sync_cron_monthday`

Data type: `String`

monthday that the ldap_sync cron should run

##### <a name="ldap_sync_cron_weekday"></a>`ldap_sync_cron_weekday`

Data type: `String`

weekday that the ldap_sync cron should run

##### <a name="ldap_sync_enable"></a>`ldap_sync_enable`

Data type: `Boolean`

Whether or not ldap_sync script is automated

##### <a name="ldap_sync_groups"></a>`ldap_sync_groups`

Data type: `Array[String]`

List of ldap groups to sync to Grafana

##### <a name="whitelabel_subtitle"></a>`whitelabel_subtitle`

Data type: `String`

Custom subtitle applied to Grafana instance

##### <a name="whitelabel_title"></a>`whitelabel_title`

Data type: `String`

Custom title applied to Grafana instance
