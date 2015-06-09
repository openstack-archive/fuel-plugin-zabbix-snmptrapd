SNMP trap daemon for Zabbix plugin
==================================

SNMP trap daemon plugin
-----------------------

SNMP trap daemon plugin extends Zabbix plugin functionality by adding
ability to receive SNMP traps from management network and pass them to Zabbix.
It installs snmptrapd daemon for receiving and snmptt for parsing and passing
traps to Zabbix. This plugin do not provide any additional monitoring checks.
It is a base for additional plugins which adds specific SNMP traps monitoring.

Requirements
------------

| Requirement                      | Version/Comment |
|:---------------------------------|:----------------|
| Mirantis OpenStack compatibility | 6.1             |
| Zabbix for Fuel plugin           | 1.0.0           |

Installation Guide
==================

SNMP trap daemon plugin installation
------------------------------------

To install SNMP trap daemon plugin, follow these steps:

1. Find and install Zabbix plugin for Fuel from
    [Fuel Plugins Catalog](https://software.mirantis.com/fuel-plugins)

2. Download SNMP trap daemon plugin for Zabbix from
    [Fuel Plugins Catalog](https://software.mirantis.com/fuel-plugins)

3. Copy the plugin on already installed Fuel Master node; ssh can be used for
    that. If you do not have the Fuel Master node yet, see
    [Quick Start Guide](https://software.mirantis.com/quick-start/) :

        # scp zabbix_snmptrapd-1.0-1.0.0-1.noarch.rpm root@<Fuel_Master_ip>:/tmp

4. Install the plugin:

        # cd /tmp
        # fuel plugins --install zabbix_snmptrapd-1.0-1.0.0-1.noarch.rpm

5. Check if the plugin was installed successfully:

        # fuel plugins
        id | name              | version | package_version
        ---|-------------------|---------|----------------
        1  | zabbix_monitoring | 1.0.0   | 2.0.0
        2  | zabbix_snmptrapd  | 1.0.0   | 2.0.0


SNMP trap daemon plugin configuration
-------------------------------------

1. Create an environment.
2. Enable Zabbix for Fuel plugin on the Settings tab of the Fuel web UI.
3. Enable SNMP trap daemon plugin on the Settings tab of the Fuel web UI.
4. Optionally, change values in the form:
   * SNMP community - SNMP community for incoming traps authorization
5. Deploy the environment.

For more information and instructions, see the SNMP trap daemon plugin Guide
in the [Fuel Plugins Catalog](https://software.mirantis.com/fuel-plugins)

Release Notes
-------------

This is the first release of the plugin.

Contributors
------------

Dmitry Klenov <dklenov@mirantis.com> (PM)  
Piotr Misiak <pmisiak@mirantis.com> (developer)  
Szymon Bańka <sbanka@mirantis.com> (developer)  
Alexander Zatserklyany <azatserklyany@mirantis.com> (QA engineer)  
