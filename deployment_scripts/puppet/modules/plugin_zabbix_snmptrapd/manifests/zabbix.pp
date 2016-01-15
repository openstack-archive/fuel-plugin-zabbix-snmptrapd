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
class plugin_zabbix_snmptrapd::zabbix {

  file { $plugin_zabbix_snmptrapd::params::server_snmp_config:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($plugin_zabbix_snmptrapd::params::server_snmp_config_template),
    notify   => Service['p_zabbix-server'],
  }

  service { 'p_zabbix-server':
    ensure   => running,
    enable   => true,
    provider => 'pacemaker',
  }

}
