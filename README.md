# v2v-demolab-ansible
V2V - Demo Lab setup - Ansible assets

## Usage

This repository provides two playbooks:
 . manageiq_create_vm.yml
 . manageiq_install.yml

The first one builds a virtual machine and runs the second playbook on it:
 . Create the virtual machine in oVirt/RHV,
 . Add it to the Ansible in-memory inventory,
 . Install git and ansible packages,
 . Clone the current git repository,
 . Generate the inventory on the virtual machine,
 . Launch the manageiq_install.yml playbook.

The second one does the actual deployment and can be used autonomously:
 . Install the YUM repositories,
 . Install dependencies,
 . Configure the database and logs disks,
 . Clone the ManageIQ and Patrick Riley's repositories
 . Bootstrap the ManageIQ setup
 . Start ManageIQ

## Configuration

The playbook that creates the VM generates the inventory and sets default
variables. However, it is possible to override these defaults, when running
the `manageiq_install.yml` playbook on a virtual machine deployed separately.
The `inventory.example.yml` file shows the options one can set.
