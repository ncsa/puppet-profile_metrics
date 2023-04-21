# @summary Pauses and starts (cycles) alerts on a schedule
#
# @param crons
#   Hash of CRON entries for pausing/starting alerts.
#   For the command key, the path to a alert_toggle script should be omitted
#
# @param enable_cycle_alerts
#   Enable or disable the cycling of alerts
#
# @param script_path
#   Path to the alert_toggle.sh script
#   
class profile_metrics_alerting::alert_cycle (
  Hash $crons,
  Boolean $enable_cycle_alerts,
  String $script_path,
) {
  Cron {
    user => 'root',
  }

  if ($enable_cycle_alerts) {
    $crons.each | $k, $v | {
      # Create new hash with command set how we want it
      $override = { 'command' => "${script_path} ${v[command]}" }

      # Merge hashes, hash on right overrides hash on left when keys are shared in both hashes
      $result = $v + $override

      cron { $k: * => $result }
    }
  } else {
    $crons.each | $k, $v | {
      cron { $k: ensure => absent }
    }
  }
}
