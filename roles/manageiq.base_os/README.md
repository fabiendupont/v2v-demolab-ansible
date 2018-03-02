manageiq.base_os
=========

This role install the bare minimal on top of the OS.

Requirements
------------

None.

Role Variables
--------------

| Variable              | Mandatory | Default | Description                                                    |
| --------------------- |:---------:|:-------:| -------------------------------------------------------------- |
| manageiq.rhn.username | No        | -       | User name to register the host against Red Hat Network         |
| manageiq.rhn.password | No        | -       | Password to register the host against Red Hat Network          |
| manageiq.rhn.pool     | No        | -       | Subscription pool to register the host against Red Hat Network |

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - role: manageiq.base_os

License
-------

GPLv3

Author Information
------------------

Fabien Dupont <fdupont@redhat.com>
