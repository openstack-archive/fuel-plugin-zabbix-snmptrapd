==================
Installation Guide
==================

SNMP trap daemon for Zabbix plugin installation
===============================================

To install SNMP trap daemon for Zabbix plugin, follow these steps:

1. Download and install the Zabbix plugin for Fuel from the
   `Fuel Plugins Catalog <https://www.mirantis.com/products/
   openstack-drivers-and-plugins/fuel-plugins/>`_.
2. Download the SNMP trap daemon for Zabbix plugin from the
   `Fuel Plugins Catalog <https://www.mirantis.com/products/
   openstack-drivers-and-plugins/fuel-plugins/>`_.
3. Copy the plugin on already installed Fuel Master node, ssh can be used for
   that. If you do not have the Fuel Master node yet, see `Quick Start Guide
   <https://software.mirantis.com/quick-start/>`_::

    # scp zabbix_snmptrapd-1.0-1.0.1-1.noarch.rpm \
      root@<The_Fuel_Master_node_IP>:/tmp

4. Log into the Fuel Master node. Install the plugin::

    # cd /tmp
    # fuel plugins --install zabbix_snmptrapd-1.0-1.0.1-1.noarch.rpm

5. Check if the plugin was installed successfully::

    # fuel plugins
    id | name                      | version  | package_version
    ---|---------------------------|----------|----------------
    1  | zabbix_monitoring         | 2.5.0    | 3.0.0
    2  | zabbix_snmptrapd          | 1.0.1    | 2.0.0

