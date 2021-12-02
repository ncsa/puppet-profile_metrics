# @summary Install and configure grafana_tools
#
# See https://github.com/jdmaloney/grafana_tools
#
# @param backup_and_sync_cron_hour
#   hour that the backup_and_sync cron should run
# @param backup_and_sync_cron_minute
#   minute that the backup_and_sync cron should run
# @param backup_and_sync_cron_month
#   month that the backup_and_sync cron should run
# @param backup_and_sync_cron_monthday
#   monthday that the backup_and_sync cron should run
# @param backup_and_sync_cron_weekday
#   weekday that the backup_and_sync cron should run
# @param backup_and_sync_destination_host
#   Host were backups are synced to
# @param backup_and_sync_destination_path
#   Path on destination host where backups are synced to
# @param backup_and_sync_enable
#   Whether or not backup_and_sync script is automated
#
# @param grafana_admin_password
#   Password of Grafana admin user
# @param grafana_admin_user
#   Username of Grafana admin user
#
# @param ldap_sync_base_dir
#   Base directory used by ldap sync
# @param ldap_sync_cron_hour
#   hour that the ldap_sync cron should run
# @param ldap_sync_cron_minute
#   minute that the ldap_sync cron should run
# @param ldap_sync_cron_month
#   month that the ldap_sync cron should run
# @param ldap_sync_cron_monthday
#   monthday that the ldap_sync cron should run
# @param ldap_sync_cron_weekday
#   weekday that the ldap_sync cron should run
# @param ldap_sync_enable
#   Whether or not ldap_sync script is automated
# @param ldap_sync_groups
#   List of ldap groups to sync to Grafana
#
# @param whitelabel_subtitle
#   Custom subtitle applied to Grafana instance
# @param whitelabel_title
#   Custom title applied to Grafana instance
#   
# @example
#   include profile_metrics_alerting::tools
class profile_metrics_alerting::tools (
  String $backup_and_sync_cron_hour,
  String $backup_and_sync_cron_minute,
  String $backup_and_sync_cron_month,
  String $backup_and_sync_cron_monthday,
  String $backup_and_sync_cron_weekday,
  String $backup_and_sync_destination_host,
  String $backup_and_sync_destination_path,
  Boolean $backup_and_sync_enable,
  String $grafana_admin_password,
  String $grafana_admin_user,
  String $ldap_sync_base_dir,
  String $ldap_sync_cron_hour,
  String $ldap_sync_cron_minute,
  String $ldap_sync_cron_month,
  String $ldap_sync_cron_monthday,
  String $ldap_sync_cron_weekday,
  Boolean $ldap_sync_enable,
  Array[String] $ldap_sync_groups,
  String $whitelabel_subtitle,
  String $whitelabel_title,
) {

  file { '/root/grafana_tools':
    ensure  => directory,
    #notify  => Exec['ensure_grafana_tools_scripts_executable'],
    recurse => true,
    replace => false,
    source  => "puppet:///modules/${module_name}/root/grafana_tools",
  }

  # chmod u+x grafana_tools scripts, but only when the file changes
  exec { 'ensure_grafana_tools_scripts_executable':
    command     => 'find /root/grafana_tools -name \'*.sh\' -exec chmod u+x {} \;',
    path        => ['/usr/bin', '/usr/sbin'],
    subscribe   => File['/root/grafana_tools'],
    refreshonly => true,
  }

  # SETUP CONFIG FILES FOR VARIOUS grafana_tools
  File_line {
    ensure => 'present',
    #replace => true,
    require => File['/root/grafana_tools'],
  }

  # backup_and_sync/config
  if ( ! empty($backup_and_sync_destination_host) ) {
    file_line { 'backup_and_sync/config destination_host':
      path  => '/root/grafana_tools/backup_and_sync/config',
      line  => "destination_host=${backup_and_sync_destination_host}",
      match => '^destination_host.*',
    }
  }
  file_line { 'backup_and_sync/config destination_path':
    path  => '/root/grafana_tools/backup_and_sync/config',
    line  => "destination_path=${backup_and_sync_destination_path}",
    match => '^destination_path.*',
  }
  file_line { 'backup_and_sync/config db':
    path  => '/root/grafana_tools/backup_and_sync/config',
    line  => "db=${::profile_metrics_alerting::db_name}",
    match => '^db=.*|^db\s.*',
  }
  file_line { 'backup_and_sync/config db_password':
    path  => '/root/grafana_tools/backup_and_sync/config',
    line  => "db_password=${::profile_metrics_alerting::db_passwd}",
    match => '^db_password.*',
  }
  file_line { 'backup_and_sync/config db_user':
    path  => '/root/grafana_tools/backup_and_sync/config',
    line  => "db_user=${::profile_metrics_alerting::db_user}",
    match => '^db_user.*',
  }

  # bulk_alert/config
  file_line { 'bulk_alert/config user':
    path  => '/root/grafana_tools/bulk_alert/config',
    line  => "user=${grafana_admin_user}",
    match => '^user.*',
  }
  file_line { 'bulk_alert/config pass':
    path  => '/root/grafana_tools/bulk_alert/config',
    line  => "pass=${grafana_admin_password}",
    match => '^pass.*',
  }

  # ldap_sync/config
  file_line { 'ldap_sync/config admin_password':
    path  => '/root/grafana_tools/ldap_sync/config',
    line  => "admin_password=\"${grafana_admin_password}\"",
    match => '^admin_password.*',
  }
  file_line { 'ldap_sync/config base_dir':
    path  => '/root/grafana_tools/ldap_sync/config',
    line  => "base_dir=\"${ldap_sync_base_dir}\"",
    match => '^base_dir.*',
  }
  $ldap_groups_joined = $ldap_sync_groups.unique.sort.join(' ')
  file_line { 'ldap_sync/config groups':
    path  => '/root/grafana_tools/ldap_sync/config',
    line  => "groups=(${ldap_groups_joined})",
    match => '^groups.*',
  }

  # white_label/config
  if ( ! empty($whitelabel_title) ) {
    file_line { 'white_label/config title':
      path  => '/root/grafana_tools/white_label/config',
      line  => "title=\"${whitelabel_title}\"",
      match => '^title.*',
    }
  }
  if ( ! empty($whitelabel_subtitle) ) {
    file_line { 'white_label/config subtitle':
      path  => '/root/grafana_tools/white_label/config',
      line  => "subtitle=\"${whitelabel_subtitle}\"",
      match => '^subtitle.*',
    }
  }

  # ADD CRONS FOR SYNC SCRIPTS
  if ( $backup_and_sync_enable ) {
    cron { 'Grafana_tools backup_and_sync sync_grafana':
      command  => '/root/grafana_tools/backup_and_sync/sync_grafana.sh 2>&1',
      user     => 'root',
      hour     => $backup_and_sync_cron_hour,
      minute   => $backup_and_sync_cron_minute,
      weekday  => $backup_and_sync_cron_weekday,
      month    => $backup_and_sync_cron_month,
      monthday => $backup_and_sync_cron_monthday,
    }
  }
  else {
    cron { 'Grafana_tools backup_and_sync sync_grafana':
      ensure => absent,
    }
  }
  if ( $ldap_sync_enable ) {
    cron { 'Grafana_tools ldap_sync':
      command  => '/root/grafana_tools/ldap_sync/sync.sh 2>&1',
      user     => 'root',
      hour     => $ldap_sync_cron_hour,
      minute   => $ldap_sync_cron_minute,
      weekday  => $ldap_sync_cron_weekday,
      month    => $ldap_sync_cron_month,
      monthday => $ldap_sync_cron_monthday,
    }
  }
  else {
    cron { 'Grafana_tools ldap_sync':
      ensure => absent,
    }
  }

}
