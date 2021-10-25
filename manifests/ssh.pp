# @summary Allow ssh between metrics servers
#
# @param metrics_node_ips
#   List of metrics node ip addresses that need sshd access
#
# @example
#   include profile_metrics::ssh
class profile_metrics::ssh (
  Array[String] $metrics_node_ips,
) {

  $params = {
    'PubkeyAuthentication'  => 'yes',
    'PermitRootLogin'       => 'without-password',
    'AuthenticationMethods' => 'publickey',
    'Banner'                => 'none',
    'X11Forwarding'         => 'no',
  }

  ::sshd::allow_from{ 'sshd allow root for metrics nodes':
    hostlist                => $metrics_node_ips,
    users                   => [ 'root' ],
    additional_match_params => $params,
  }

}
