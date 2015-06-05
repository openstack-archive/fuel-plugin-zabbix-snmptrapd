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

  file_line { 'enable SNMPTrapper in Zabbix':
    path     => '/etc/zabbix/zabbix_server.conf',
    match    => 'StartSNMPTrapper',
    line     => 'StartSNMPTrapper=1',
    notify   => Service['p_zabbix-server'],
  }

  file_line { 'set SNMPTrapperFile in Zabbix':
    path     => '/etc/zabbix/zabbix_server.conf',
    match    => 'SNMPTrapperFile',
    line     => 'SNMPTrapperFile=/var/log/snmptt/snmptt.log',
    notify   => Service['p_zabbix-server'],
  }

  service { 'p_zabbix-server':
    ensure   => running,
    enable   => true,
    provider => 'pacemaker',
  }

}
