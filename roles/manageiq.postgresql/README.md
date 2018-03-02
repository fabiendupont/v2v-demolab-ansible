Role Name
=========

manageiq.postgresql - This role deploys PostgreSQL for ManageIQ

Requirements
------------

None

Role Variables
--------------

| Variable                        | Mandatory | Default      | Description                                       |
| ------------------------------- |:---------:|:------------:| ------------------------------------------------- |
| manageiq_postgresql_version     | Yes       | 9.5          | Version of PostgreSQL to install                  |
| manageiq_postgresql_disk        | Yes       | -            | Disk on which PostgreSQL stores its data          |
| manageiq_postgresql_vg_name     | Yes       | vg_miq_pgsql | Name of the volume group created for PostgreSQL   |
| manageiq_postgresql_lv_name     | Yes       | lv_data      | Name of the logical volume created for PostgreSQL |
| manageiq_postgresql_db_password | Yes       | smartvm      | Password to connect to the database               |

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - role: manageiq.postgresql
           manageiq_postgresql_disk: "/dev/sdb"

License
-------

GPLv3

Author Information
------------------

Fabien Dupont <fdupont@redhat.com>
