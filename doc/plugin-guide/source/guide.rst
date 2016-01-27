==========
User Guide
==========

Environment configuration
=========================

1. Create an environment. For more information about environment creation, see
   `Mirantis OpenStack User Guide <http://docs.mirantis.com/openstack/fuel
   /fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.
2. Enable and configure Zabbix plugin for Fuel. For instructions, see Zabbix
   Plugin Guide in the `Fuel Plugins Catalog <https://www.mirantis.com
   /products/openstack-drivers-and-plugins/fuel-plugins/>`_.
3. Open *Settings* tab of the Fuel web UI and scroll the page down. On the left
   choose *SNMP trap daemon for Zabbix plugin*, select the plugin checkbox and
   set *SNMP community* parameter:

   .. image:: ../images/settings.png
      :width: 100%

   You could see default value by clicking on the eye icon. It is highly
   recommended to change default SNMP community, because it is used to
   authorize incoming SNMP traps.
4. Adjust other environment settings to your requirements and deploy the
   environment. For more information, see
   `Mirantis OpenStack User Guide <http://docs.mirantis.com/openstack/fuel
   /fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.

Environment validation
======================

After a successful deployment, all Controller Nodes should have the following:

1. snmptrapd daemon running and listening on UDP/162 port on the VIP address
   reserved for Zabbix.
2. snmptrapd daemon configured to pass all SNMP traps to snmptt handler.
3. snmptt daemon running which parse SNMP traps and stores them in a log file
   in a format accepted by Zabbix.
4. Zabbix SNMPTrapper processes running which reads SNMP traps from the log
   file (only on node on which Zabbix Server is running).

To test if everything is installed and configured properly, follow these steps:

1. Generate a test SNMP trap running following command from any node::

       [root@node-46 ~]# snmptrap -v 2c -c <SNMP_community> \
       <zabbix_VIP_address> "" .1.3.6.1.4.1.8072.2.3.0.1

   where:

   *<SNMP_ community>*

       It is set in the SNMP trap daemon for Zabbix plugin Settings in Fuel UI:

   .. image:: ../images/settings.png
      :width: 100%

   *<zabbix_VIP_address>*

       If you don’t know the address, run the following command on any node::

           [root@node-46 ~]# grep -A2 ^zbx_vip_mgmt /etc/astute.yaml

       You should get the required VIP in the output::

           zbx_vip_mgmt:
             network_role: zabbix
             ipaddr: 192.168.0.1


2. After several seconds of running the snmptrap command you should see a line
   in the Zabbix Server log file similar to this one::

       [root@node-45 ~]# grep netSnmpExampleHeartbeatNotification \
       /var/log/zabbix/zabbix_server.log
       10730:20150611:182933.176 unmatched trap received from [192.168.0.4]:
       18:29:27 2015/06/11 .1.3.6.1.4.1.8072.2.3.0.1 Normal "Status Events"
       node-46.domain.tld - netSnmpExampleHeartbeatNotification

   This is a proof that test SNMP trap has been received and passed to Zabbix.
   It is “unmatched” for Zabbix because there is no configuration for this trap
   in Zabbix (this trap is for testing purposes only).


How to use SNMP trap daemon for Zabbix plugin
=============================================

As noted above, with this plugin you can easily create additional plugins to
add monitoring of SNMP traps specific for your hardware. To achieve this,
the following tasks should be done by additional plugin:

1. On all Controller nodes, add SNMP traps to snmptt configuration:

   a. Create configuration file in */etc/snmp/snmptt.conf.d/* directory, for
      example *emc.conf*, with SNMP traps defined, for more information, see
      `snmptt documentation <http://snmptt.sourceforge.net/docs/snmptt.shtml
      #SNMPTT.CONF-Configuration-file-format>`_.
   b. Add the file (absolute path) to *snmptt_conf_files* parameter in
      *snmptt.ini* file.
   c. Reload snmptt service.

2. Create a Zabbix monitoring Template and export it to a file. For more
   information, see `Templates section in the Zabbix documentation <https://
   www.zabbix.com/documentation/2.4/manual/config/templates>`_.
3. From Primary Controller node configure Zabbix:

   a. Copy created Template file to the Primary Controller node.
   b. Import the Template to Zabbix using *plugin_zabbix_configuration_import*
      resource.
   c. Optionally, create a Host group in Zabbix using *plugin_zabbix_hostgroup*
      resource.
   d. Create Host in Zabbix using *plugin_zabbix_host* resource setting
      appropriate name, IP and group.
   e. Link the Template with the Host using *plugin_zabbix_template_link*
      resource.

There are two plugins in the `Fuel Plugins Catalog <https://www.mirantis.com
/products/openstack-drivers-and-plugins/fuel-plugins/>`_ you can refer to as an
example:

1. EMC hardware monitoring extension for Zabbix plugin.
2. Extreme Networks hardware monitoring extension for Zabbix plugin.

These plugins do all the tasks mentioned above and have their own Zabbix
monitoring Templates. You can simply copy one of these plugins and adjust SNMP
traps configuration to your hardware. For more information about Fuel Plugins
development, see `Fuel Plugins wiki page <https://wiki.openstack.org/wiki/Fuel
/Plugins>`_.

