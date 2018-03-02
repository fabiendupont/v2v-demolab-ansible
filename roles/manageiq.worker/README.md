manageiq.worker
=========

This role deploys ManageIQ worker

Requirements
------------

None

Role Variables
--------------

| Variable              | Mandatory | Default     | Description                                 |
| --------------------- |:---------:|:-----------:| ------------------------------------------- |
| manageiq_ruby_version | Yes       | 2.4         | Version of Ruby to install                  |
| manageiq_logs_disk    | Yes       | -           | Disk on which ManageIQ stores its logs      |
| manageiq_logs_vg_name | Yes       | vg_miq_logs | Name of the volume group created for logs   |
| manageiq_logs_lv_name | Yes       | lv_data     | Name of the logical volume created for logs |

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - role: manageiq.postgresql
           manageiq_logs_disk: "/dev/sdb"

License
-------

GPLv3

Author Information
------------------

Fabien Dupont <fdupont@redhat.com>
