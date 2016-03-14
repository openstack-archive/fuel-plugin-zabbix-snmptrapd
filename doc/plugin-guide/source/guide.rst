==========
User Guide
==========

Important preliminary notes
===========================

- It is highly recommended to do a network verification check prior
  to any deployment.
- This plugin version only supports Ubuntu OS type.
- You can also choose any supervisor and/or also change the
  networking configuration according to your needs  but you can not use
  the old legacy networking mode (nova-network) as this is not supported.
- See Zabbix Plugin for Fuel Documentation for additional notes

Known problems
==============

- `#1529643 <https://bugs.launchpad.net/fuel-plugins/+bug/1529643>`_:
  Zabbix snmptrapd: Service "snmptt" was restarted after executing of task "upload\_core\_repos"
- `#1538617 <https://bugs.launchpad.net/fuel-plugins/+bug/1538617>`_:
  Cross-plugin display restrictions for some plugins prevent Settings tab from opening.
- See Zabbix Plugin for Fuel Documentation for additional problems

Environment configuration
=========================

.. highlight:: none

#. Create an environment. For more information about environment creation, see
   `Mirantis OpenStack User Guide <http://docs.mirantis.com/openstack/fuel
   /fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.

#. Enable and configure Zabbix plugin for Fuel. For instructions, see Zabbix
   Plugin Guide in the `Fuel Plugins Catalog <https://www.mirantis.com
   /products/openstack-drivers-and-plugins/fuel-plugins/>`_.

#. Open *Settings* tab of the Fuel web UI and scroll the page down. On the left
   choose *SNMP trap daemon for Zabbix plugin*, select the plugin checkbox and
   set *SNMP community* parameter:

   .. image:: ../images/settings.png
      :width: 100%

   You could see default value by clicking on the eye icon. It is highly
   recommended to change default SNMP community, because it is used to
   authorize incoming SNMP traps.

#. Adjust other environment settings to your requirements and deploy the
   environment. For more information, see
   `Mirantis OpenStack User Guide <http://docs.mirantis.com/openstack/fuel
   /fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.

Environment validation
======================

After a successful deployment, all Controller Nodes should have the following:

#. snmptrapd daemon running and listening on UDP/162 port on the VIP address
   reserved for Zabbix.

#. snmptrapd daemon configured to pass all SNMP traps to snmptt handler.

#. snmptt daemon running which parse SNMP traps and stores them in a log file
   in a format accepted by Zabbix.

#. Zabbix SNMPTrapper processes running which reads SNMP traps from the log
   file (only on node on which Zabbix Server is running).

To test if everything is installed and configured properly, follow these steps:

#. Generate a SNMP test trap by running the following command from any node::

     # snmptrap -v 2c -c <SNMP_community> <mgmt_VIP_address> "" \
         .1.3.6.1.4.1.8072.2.3.0.1

   where:

   *<SNMP_ community>*

       It is set in the SNMP trap daemon for Zabbix plugin Settings in Fuel UI:

   .. image:: ../images/settings.png
      :width: 100%

   *<mgmt_VIP_address>*

       If you don’t know the address, run the following command on any node::

	 # awk '/zbx_vip_mgmt/ {n=1} n==1 && /ipaddr/ {print;exit}' \
	       /etc/astute.yaml | sed -e 's/.*: //'

       You should get the required VIP in the output::

	 192.168.0.3

#. After several seconds of running the snmptrap command you should see a line
   in the Zabbix Server log file similar to this one::

     # grep netSnmpExampleHeartbeatNotification /var/log/zabbix/zabbix_server.log
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

#. On all Controller nodes, add SNMP traps to snmptt configuration:

   #. Create configuration file in */etc/snmp/snmptt.conf.d/* directory, for
      example *emc.conf*, with SNMP traps defined, for more information, see
      `snmptt documentation <http://snmptt.sourceforge.net/docs/snmptt.shtml
      #SNMPTT.CONF-Configuration-file-format>`_.

   #. Add the file (absolute path) to *snmptt_conf_files* parameter in
      *snmptt.ini* file.

   #. Reload snmptt service.

#. Create a Zabbix monitoring Template and export it to a file. For more
   information, see `Templates section in the Zabbix documentation <https://
   www.zabbix.com/documentation/2.4/manual/config/templates>`_.

#. From Primary Controller node configure Zabbix:

   #. Copy created Template file to the Primary Controller node.

   #. Import the Template to Zabbix using *plugin_zabbix_configuration_import*
      resource.

   #. Optionally, create a Host group in Zabbix using *plugin_zabbix_hostgroup*
      resource.

   #. Create Host in Zabbix using *plugin_zabbix_host* resource setting
      appropriate name, IP and group.

   #. Link the Template with the Host using *plugin_zabbix_template_link*
      resource.

There are two plugins in the `Fuel Plugins Catalog <https://www.mirantis.com
/products/openstack-drivers-and-plugins/fuel-plugins/>`_ you can refer to as an
example:

#. EMC hardware monitoring extension for Zabbix plugin.

#. Extreme Networks hardware monitoring extension for Zabbix plugin.

These plugins do all the tasks mentioned above and have their own Zabbix
monitoring Templates. You can simply copy one of these plugins and adjust SNMP
traps configuration to your hardware. For more information about Fuel Plugins
development, see `Fuel Plugins wiki page <https://wiki.openstack.org/wiki/Fuel
/Plugins>`_.

