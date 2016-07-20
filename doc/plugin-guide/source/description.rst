===============================================
Guide to the SNMP trap daemon for Zabbix plugin
===============================================

This plugin extends Zabbix plugin functionality by adding ability to receive
SNMP traps from management network and pass them to Zabbix. For more
information about networks, see the `Logical Networks <https://
docs.mirantis.com/openstack/fuel/fuel-7.0/reference-architecture.html
#logical-networks>`_ section of MOS documentation. The plugins installs
snmptrapd daemon for receiving and snmptt software for parsing and passing
traps to Zabbix. This plugin does not provide any additional features from user
point of view. It was designed as a base for other plugins which needs to
analyze SNMP traps incoming from for example network and storage hardware like
network switches or storage arrays. By using this plugin user can easily create
additional plugins to add monitoring of SNMP traps specific for their hardware.

Requirements
============

====================== ================
Requirement            Version/Comment
====================== ================
Fuel                   7.0, 8.0 and 9.0
Zabbix plugin for Fuel 2.5.1
====================== ================

