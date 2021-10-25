# @summary Allow ssh between metrics servers
#
# @param metrics_node_ips
#   List of metrics node ip addresses that need sshd access
#
# @param sshkey_pub
#   Public part of root's sshkey.
#
# @param sshkey_priv
#    Private part of root's sshkey.
#
# @param sshkey_type
#    OPTIONAL - defaults to "rsa"
#
# @example
#   include profile_metrics_alerting::ssh
class profile_metrics_alerting::ssh (
  Array[String] $metrics_node_ips,
  String $sshkey_pub,
  String $sshkey_priv,
  String $sshkey_type,
) {

  # NEED TO SETUP SOME SSH KEYS USED FOR SYNCING DATA BETWEEN METRICS HOSTS

  # Secure sensitive data to prevent it showing in logs
  #$pubkey = Sensitive( $sshkey_pub )
  $pubkey = $sshkey_pub
  $privkey = Sensitive( $sshkey_priv )

  # Local variables

  $sshdir = '/root/.ssh'

  $file_defaults = {
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0600',
    require =>  File[ $sshdir ],
  }

  # Define unique parameters of each resource
  $data = {
    $sshdir => {
      ensure => directory,
      mode   => '0700',
      require => [],
    },
    "${sshdir}/id_${sshkey_type}" => {
      content => $privkey,
    },
    "${sshdir}/id_${sshkey_type}.pub" => {
      content => "ssh-${sshkey_type} ${pubkey} root@metrics\n",
      mode    => '0644',
    },
  }

  # Ensure the resources
  ensure_resources( 'file', $data, $file_defaults )

  ssh_authorized_key { 'root@metrics':
    ensure => present,
    user   => 'root',
    type   => "ssh-${sshkey_type}",
    key    => $pubkey,
  }


  # SSHD CONFIGURATION

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
