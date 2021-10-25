# profile_metrics

![pdk-validate](https://github.com/ncsa/puppet-profile_metrics/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_metrics/workflows/yamllint/badge.svg)

NCSA Common Puppet Profiles - configure metrics services for ICI monitoring

## Usage

To install and configure:

```puppet
include profile_metrics
```

## Configuration

The following parameters need to be set in hiera:
```
profile_metrics::cilogon_client_id: ""cilogon:/client_id/UNIQUEID"
profile_metrics::cilogon_client_secret: "SECRETKEY"
profile_metrics::db_passwd: "PASSWORD"
```

## Dependencies

- [ncsa/sshd](https://github.com/ncsa/puppet-sshd)
- [puppet/grafana](https://forge.puppet.com/modules/puppet/grafana)
- [puppetlabs/mysql](https://forge.puppet.com/modules/puppetlabs/mysql)

## Reference

[REFERENCE.md](REFERENCE.md)

