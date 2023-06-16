# @summary Configure Grafana tools backups
#
# @example
#   include profile_metrics_alerting::backup
class profile_metrics_alerting::backup {
  if ( lookup('profile_backup::client::enabled') ) {
    include profile_backup::client

    profile_backup::client::add_job { 'profile_metrics_alerting':
      paths             => [
        '/etc/grafana',
        '/tmp/grafana_backup_*',
      ],
      prehook_commands  => [
        '/root/grafana_tools/backup_and_sync/backup_grafana.sh',
      ],
      posthook_commands => [
        'find /tmp/grafana_backup_* -mtime +1 -delete',
      ],
    }
  }
}
