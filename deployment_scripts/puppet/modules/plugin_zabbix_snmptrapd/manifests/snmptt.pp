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
class plugin_zabbix_snmptrapd::snmptt {

  if $::osfamily == 'RedHat' {
    package { 'net-snmp-perl':
      ensure => present,
      before => Package['snmptt'],
    }
  }

  package { 'snmptt':
    ensure   => present,
  }

  service { 'snmptt':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    require   => Package['snmptt'],
  }

  file { '/etc/snmp/snmptt.ini':
    ensure   => present,
    mode     => '0644',
    owner    => 'root',
    group    => 'root',
    source   => 'puppet:///modules/plugin_zabbix_snmptrapd/snmptt.ini',
    require  => Package['snmptt'],
    notify   => Service['snmptt'],
  }

  file { '/etc/snmp/snmptt.conf':
    ensure   => present,
    mode     => '0644',
    owner    => 'root',
    group    => 'root',
    source   => 'puppet:///modules/plugin_zabbix_snmptrapd/snmptt.conf',
    require  => Package['snmptt'],
    notify   => Service['snmptt'],
  }

  file_line { 'in logrotate disable compressing of snmptt logfiles':
    path     => '/etc/logrotate.d/snmptt',
    match    => 'compress',
    line     => 'nocompress',
    require  => Package['snmptt'],
  }

}
