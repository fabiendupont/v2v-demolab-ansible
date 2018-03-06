# v2v-demolab-ansible
V2V - Demo Lab setup - Ansible assets

## Usage

This repository provides two playbooks:
 . manageiq_create_vm.yml
 . manageiq_install.yml

The first one builds a virtual machine and runs the second playbook on it:
 . Creates the virtual machine in oVirt/RHV,
 . Adds it to the Ansible in-memory inventory,
 . Installs git and ansible packages,
 . Clones the current git repository,
 . Generates the inventory on the virtual machine,
 . Launches the manageiq_install.yml playbook.

The second one does the actual deployment and can be used autonomously:
