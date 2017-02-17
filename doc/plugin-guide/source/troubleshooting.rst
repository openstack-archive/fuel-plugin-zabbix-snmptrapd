===============
Troubleshooting
===============

.. highlight:: none

Running processes
=================

After a successfull deployment the following processes should be running on
the controller node which runs the Zabbix server (lines have been wrapped
for more readability)::

  root     10222     1  0 13:54 ?        00:00:00   
           /usr/sbin/snmptrapd -Lsd -p /var/run/snmptrapd.pid
  root     10330     1  0 13:54 ?        00:00:00   
           /usr/bin/perl /usr/sbin/snmptt --daemon
  snmptt   10331 10330  0 13:54 ?        00:00:00     
           /usr/bin/perl /usr/sbin/snmptt --daemon
  snmp     19521     1  0 13:49 ?        00:00:00   
           /usr/sbin/snmpd -Lsd -Lf /dev/null -u snmp -g snmp -I 
               -smux mteTrigger mteTriggerConf -p /var/run/snmpd.pid

This processes ensure that the SNMP traps can be handled by Zabbix

If some of them do not run, please try to relaunch them appropriately using one of the following commands::

  # service snmpd restart
  # service snmptt restart

For the snmptrapper process, please make sure the contents of the corresponding
Zabbix configuration file is accurate::

  # cat /etc/zabbix/conf.d/zabbix_snmp.conf 
  ### Managed by Puppet ###
  # This is SNMP config file for ZABBIX server process
  # To get more information about ZABBIX,
  # go http://www.zabbix.com

  ############ GENERAL PARAMETERS #################

  #SNMP Trapper
  StartSNMPTrapper=1
  SNMPTrapperFile=/var/log/snmptt/snmptt.log

and potentially restart the Zabbix server process which is managed by pacemaker.
See Zabbix Plugin for Fuel Documentation to see how to do this.

Finding the management VIP to use to send SNMP traps
====================================================

On the Fuel master node, use the primary controller node (here node-3)::

  # ssh -q node-3 ip netns exec zabbix ifconfig b_zbx_vip_mgmt | \
      grep 'inet addr:' | sed -e 's/[^:]*://' -e 's/ .*//'
  192.168.0.3

Note that there is another way to find this::

  # ssh -q node-3 "awk '/zbx_vip_mgmt/ {n=1} n==1 && /ipaddr/ {print;exit}' \
      /etc/astute.yaml" | sed -e 's/.*: //'
  192.168.0.3

SNMP processes log files
========================

The files can be found under::

  /var/log/snmptt/snmpttsystem.log

Zabbix log files
================

On any of the cluster node, you might want to look into the Zabbix
agents and server log files under::

  /var/log/zabbix

Additional reading
==================

See Zabbix Plugin for Fuel Documentation for additional troubleshooting tips

