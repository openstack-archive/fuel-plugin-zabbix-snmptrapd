..
 This work is licensed under the Apache License, Version 2.0.

 http://www.apache.org/licenses/LICENSE-2.0

==================================
SNMP trap daemon for Zabbix plugin
==================================

SNMP trap daemon plugin extends Zabbix plugin functionality by adding
ability to receive SNMP traps from management network and pass them to Zabbix.
It installs snmptrapd daemon for receiving and snmptt for parsing and passing
traps to Zabbix. This plugin do not provide any additional monitoring checks.
It is a base for additional plugins which adds specific SNMP traps monitoring.

Problem description
===================

Currently, Zabbix plugin for Fuel has no support for receiving and analyzing
SNMP traps from external hardware like EMC VNX arrays or network switches.
SNMP trap daemon for Zabbix plugin aims to provide a support for it.

Proposed change
===============

Implement a Fuel plugin that will install and configure snmptrapd daemon for
receiving and snmptt for parsing and passing traps to Zabbix.

Alternatives
------------

It might have been implemented as part of Zabbix plugin for Fuel but we decided
to make it as a separate plugin for several reasons:

* This isn't something that all operators may want to deploy.
* Any new additional functionality makes the project's testing more difficult,
  which is an additional risk for the Zabbix plugin for Fuel release.

Data model impact
-----------------

None

REST API impact
---------------

None

Upgrade impact
--------------

None

Security impact
---------------

UDP/162 port opened on management VIP address on Controller nodes

Notifications impact
--------------------

None

Other end user impact
---------------------

None

Performance Impact
------------------

None

Other deployer impact
---------------------

None

Developer impact
----------------

None

Implementation
==============

The plugin installs and configures snmptrapd daemon using snmpd puppet module.
It also installs and configures snmptt software for parsing SNMP traps and
passing them to Zabbix. The plugin delivers required official packages which
are not included in Mirantis OpenStack.

The plugin has one task which is run on all Controller nodes and does following
actions:

* installs and configures snmptrapd daemon
* installs and configures snmptt
* enables SNMPTrapper in Zabbix


Assignee(s)
-----------

| Dmitry Klenov <dklenov@mirantis.com> (PM)
| Piotr Misiak <pmisiak@mirantis.com> (developer)
| Szymon Bańka <sbanka@mirantis.com> (developer)
| Alexander Zatserklyany <azatserklyany@mirantis.com> (QA engineer)
| Swann Croiset <scroiset@mirantis.com> (developer)
| Olivier Bourdon <obourdon@mirantis.com> (developer)

Work Items
----------

* Implement the Fuel plugin.
* Implement the Puppet manifests.
* Testing.
* Write the documentation.

Dependencies
============

* Fuel 7.0, 8.0, 9.0, 9.1 and 9.2
* Zabbix plugin for Fuel 2.5.2

Testing
=======

* Prepare a test plan.
* Test the plugin by deploying environments with all Fuel deployment modes.

Documentation Impact
====================

* User Guide (which features the plugin provides, how to use them in the
  deployed OpenStack environment).
* Test Plan.
* Test Report.

References
==========

* `Zabbix Documentation - SNMP traps
  <https://www.zabbix.com/documentation/2.4/manual/config/items/itemtypes/snmptrap>`_
