#
#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
class plugin_zabbix_snmptrapd {

  include plugin_zabbix_snmptrapd::params

  $service_name     = $plugin_zabbix_snmptrapd::params::service_name
  $daemon_pkg_name  = $plugin_zabbix_snmptrapd::params::daemon_pkg_name
  $utils_pkg_name   = $plugin_zabbix_snmptrapd::params::utils_pkg_name
  $trapd_pkg_name   = $plugin_zabbix_snmptrapd::params::trapd_pkg_name

  $plugin_settings  = hiera('zabbix_snmptrapd')

  $network_metadata = hiera('network_metadata')
  $server_ip        = $network_metadata['vips']['zbx_vip_mgmt']['ipaddr']
  $server_port      = '162'

  class { 'snmp':
    snmptrapdaddr       => ["udp:${server_ip}:${server_port}"],
    ro_community        => $plugin_settings['community'],
    service_ensure      => 'stopped',
    trap_service_ensure => 'running',
    trap_service_enable => true,
    trap_handlers       => ['default /usr/sbin/snmptthandler'],
  }

  firewall { '998 snmptrapd':
    proto  => 'udp',
    action => 'accept',
    port   => $server_port,
  }

  package { $utils_pkg_name:
    ensure => 'present',
    name   => $utils_pkg_name,
  }

  # The following is true on Xenial based systems (MOS >= 10.0)
  if $trapd_pkg_name {
    package { $trapd_pkg_name:
      ensure => 'present',
      name   => $trapd_pkg_name,
    }
    Package[$trapd_pkg_name] -> Package[$daemon_pkg_name]
  }

  # The following resource overwrites default initscript for snmptrapd.
  # Version provided by the plugin supports namespaces.
  # If there is a need to run snmptrad in a specific namespace,
  # uncomment the following resource and put the correct namespace in the file.
  file { "/etc/init.d/${service_name}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/plugin_zabbix_snmptrapd/initscripts/${service_name}",
    require => [Package[$daemon_pkg_name], Package[$utils_pkg_name]],
    notify  => Service[$service_name],
  }

  class { 'plugin_zabbix_snmptrapd::snmptt':
    require => Class['snmp'],
  }

  class { 'plugin_zabbix_snmptrapd::zabbix':
    require => Class['plugin_zabbix_snmptrapd::snmptt'],
  }

}
