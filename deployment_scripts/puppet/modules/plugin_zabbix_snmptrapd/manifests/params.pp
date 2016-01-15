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
class plugin_zabbix_snmptrapd::params {

  case $::osfamily {
    'Debian': {
      $service_name = 'snmpd'
      $package_name = 'snmpd'
    }
    'RedHat': {
      $service_name = 'snmptrapd'
      $package_name = 'net-snmp'
    }
    default: {
      fail("unsuported osfamily ${::osfamily}, currently Debian and RedHat are the only supported platforms")
    }
  }

  $zabbix_base_conf_dir        = '/etc/zabbix'
  $zabbix_extra_conf_subdir    = 'conf.d'
  $zabbix_extra_conf_dir       = "${zabbix_base_conf_dir}/${zabbix_extra_conf_subdir}"
  $server_snmp_config          = "${zabbix_extra_conf_dir}/zabbix_snmp.conf"
  $server_snmp_config_template = 'plugin_zabbix_snmptrapd/zabbix_snmp.conf.erb'

}
