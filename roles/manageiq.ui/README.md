manageiq.ui
=========

This role deploys ManageIQ UI

Requirements
------------

None

Role Variables
--------------

| Variable              | Mandatory | Default | Description                |
| --------------------- |:---------:|:-------:| -------------------------- |
| manageiq_ruby_version | Yes       | 2.4     | Version of Ruby to install |

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - role: manageiq.ui

License
-------

GPLv3

Author Information
------------------

Fabien Dupont <fdupont@redhat.com>
