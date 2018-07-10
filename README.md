# V2V - Demo Lab setup - Ansible

## Usage

This repository provides a playbook, [deploy.yml](../blob/master/deploy.yml),
that installs the V2V environment on top of an oVirt / RHV environment. It
deploys a ManageIQ appliance using the latest nightly build, then it adds the
providers, configures the conversion hosts and add the V2V assets to the
ManageIQ appliance: appliance role, automate code, conversion hosts
credentials.

__Every action is done as root on the oVirt/RHV Manager machine.__

## Installation

This version lives in a specific branch of the repo, so we need to check this
branch out:

```
$ git clone https://github.com/fdupont-redhat/v2v-demolab-ansible.git
$ cd v2v-demolab-ansible
$ git checkout deploy_from_rhvm
```

Currently, the playbook relies on features only available in unreleased version
of oVirt.manageiq role, so we have install it from Github:


```
$ git clone https://github.com/oVirt/ovirt-ansible-manageiq.git roles/oVirt.manageiq
```

On the oVirt/RHV Manager, also ensure you have the
`ovirt-ansible-v2v-conversion-host` package installed.

## Usage

The following command line will launch the playbook:

```
$ ansible-playbook deploy.yml -e @extra_vars.yml --ask-vault-pass
```

The `extra_vars.yml` is not provided as it is specific to your environment.
A example file is provided
[extra_vars.example.yml](../blob/deploy_from_rhvm/extra_vars.example.yml), so that you
can see what variables are available. Copy it to `extra_vars.yml` and adapt it
to your environment.

A example inventory is also provided:
[inventory.example.yml](../blob/deploy_from_rhvm/inventory.example.yml). Copy it to
`inventory.yml` and adapt it to your environment.

## Variables

__You will have to provide some passwords, so consider using file encrypted by
ansible-vault to protect them.__

Most of the variables come from the
[oVirt.manageiq](https://github.com/oVirt/ovirt-ansible-manageiq) role, so we
advise that you also read its documentation for further customization.

The follwing variables allow to connect to the oVirt / RHV API.

| Variable        | Description                               |
| --------------- | ----------------------------------------- |
| engine_fqdn     | Hostname of the oVirt / RHV engine server |
| engine_user     | Username of the oVirt / RHV engine server |
| engine_password | Password of the oVirt / RHV engine server |

The following variables allow the creation of the virtual machine, as well as
the configuration of the providers. By default, a oVirt / RHV provider is
created for the platform on which ManageIQ is deployed. The
`miq_extra_providers` allows to add more providers, such as the VMware source
providers. See [extra_vars.example.yml](../blob/master/extra_vars.example.yml)
for an example.

| Variable              | Description                                                          |
| --------------------- | -------------------------------------------------------------------- |
| miq_qcow_url          | URL of the appliance to deploy (QCOW file)                           |
| miq_vm_name           | Name of the VM                                                       |
| miq_vm_root_password  | Root password of the VM                                              |
| miq_vm_cluster        | Name of the oVirt / RHV cluster where to deploy the VM               |
| miq_vm_memory_gb      | Amount of memory to allocate to the VM in GB                         |
| miq_vm_cpus           | Number of vCPUs to allocate to the VM                                |
| miq_vm_ip_address     | IP address of the VM                                                 |
| miq_vm_netmask        | Netmask of the VM                                                    |
| miq_vm_gateway        | Gateway of the VM                                                    |
| miq_vm_dns_servers    | DNS servers                                                          |
| miq_vm_dns_domain     | DNS domain                                                           |
| miq_vm_cloud_init     | Cloud-init configuration to use (see oVirt.manageiq role)            |
| miq_rhv_provider_name | Name of the provider configured for the current oVirt / RHV platform |
| miq_extra_providers   | Additional providers to create during deployement                    |
| miq_v2v_automate_ref  | Branch of the v2v-automate domain to use (default: master)           |

Virtual machine extra disks (e.g. database, log, tmp): a dict named
`miq_vm_disks` allows to describe each of the extra disks (see example
playbook). For each disk, the following attributes can be set:

| Name      | Default value |  Description                                                         |
|-----------|---------------|----------------------------------------------------------------------|
| name      | UNDEF         | The name of the virtual machine disk. i                              |
| size      | UNDEF         | The virtual machine disk size (`XXGiB`).                             |
| interface | UNDEF         | The virtual machine disk interface type (`virtio` or `virtio_scsi`). |
| format    | UNDEF         | The format of the virtual machine disk (`raw` or `cow`).             |

The following variables are used to configure the conversion host during the
deployemnt.

| Variable              | Description                                    |
| --------------------- | ---------------------------------------------- |
| v2v_repo_rpms_name    | Name of the repository for V2V packages        |
| v2v_repo_rpms_url     | URL of the repository for V2V packages         |
| v2v_repo_srpms_name   | Name of the repository for V2V source packages |
| v2v_repo_srpms_url    | URL of the repository for V2V source packages  |
| v2v_vddk_package_name | Name of the VDDK archive                       |
| v2v_vddk_package_url  | URL of the VDDK archive                        |

## Tags

In order to allow people to run specific parts of the playbook, we have
implemented tags. Here is a list of available tags:

| Tag              | Description                                                         |
| ---------------- | ------------------------------------------------------------------- |
| inventory        | Ensures that ManageIQ appliance is added to the in memory inventory |
| conversion_host  | Configure conversion hosts                                          |
| extra_providers  | Add providers to ManageIQ                                           |
| manageiq_roles   | Activate required ManageIQ roles                                    |
| automate_domains | Add the V2V automate domain                                         |
| ssh_keys         | Deploys ManageIQ SSH key on RHV-M                                   |
