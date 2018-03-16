# v2v-demolab-ansible
V2V - Demo Lab setup - Ansible assets

## Usage

This repository provides two playbooks:

 * [manageiq_create_vm.yml](../blob/master/manageiq_create_vm.yml)
 * [manageiq_install.yml](../blob/master/manageiq_install.yml)

The first one builds a virtual machine and runs the second playbook on it:
 * Create the virtual machine in oVirt/RHV,
 * Add it to the Ansible in-memory inventory,
 * Install git and ansible packages,
 * Clone the current git repository,
 * Generate the inventory on the virtual machine,
 * Launch the manageiq_install.yml playbook.

The second one does the actual deployment and can be used autonomously:
 * Install the YUM repositories,
 * Install dependencies,
 * Configure the database and logs disks,
 * Clone the ManageIQ and Patrick Riley's repositories
 * Bootstrap the ManageIQ setup
 * Start ManageIQ

If you want to build from scratch, run the `manageiq_create_vm.yml` playbook,
passing your config file, preferably encrypted by ansible-vault:

```
$ ansible-playbook manageiq_create_vm.yml \
    -e @config/manageiq_vm.yml \
    -e @config/ovirt_auth.yml \
    --ask-vault-pass
```

If you already have a CentOS 7 or RHEL 7 VM, you can run `manageiq_install.yml`
playbook from that VM, after setting the inventory.

```
# ansible-playbook manageiq_install.yml
```

## Prerequisites

If you take a look at the playbooks, the main prerequisite is a virtual machine
running CentOS 7 or RHEL 7. __Currently, only CentOS 7 has been tested__.

To use the playbook that creates the VM, you will need a VM template in your
oVirt / RHV4 environment. This template will have to support cloud-init. Here
is a small how-to, based on a CentOS 7 minimal install.

First, let's install some commonly used packages.

```
# yum -y install vim-enhanced screen bash-completion yum-utils
```

Then, we install the oVirt agent for a better integration.
```
# yum -y install centos-release-ovirt42
# yum -y install ovirt-guest-agent-common
# systemctl enable --now ovirt-guest-agent.service
```

Now, we install cloud-init.
```
# yum -y install cloud-init
```

Due to a race condition in dbus startup and cloud-init, all operations using
hostnamectl as a backend fail. To workaround this, we move them to a later
stage.
```
# sed -i \
    -e "/set_hostname/d" \
    -e "/update_hostname/d" \
    -e "/^cloud_config_modules:/a \ - set_hostname\n - update_hostname" \
    /etc/cloud/cloud.cfg
```

Finally, we _seal_ the VM and shut it down.
```
# yum clean all
# rm -rf /var/cache/yum/
# for i in /etc/sysconfig/network-scripts/ifcfg-eth* ; do
    sed -i -e '/^UUID=/d' -e '/^ONBOOT=/s/=.*$/=yes/' ${i}
done
# rm -f /etc/ssh/ssh_host_*
# echo > ~/.bash_history
# history -c
# halt -p
```

## Configuration

The `manageiq_create_vm.yml` allows a few variables to be passed. Some of them
are passwords, so you may want to use vault files to store them. Personally, I
use three configuration based on the following example files.

[config/manageiq_vm.example.yml](../blob/master/config/manageiq_vm.example.yml)

| Variable                     | Description                                      |
| ---------------------------- | ------------------------------------------------ |
| manageiq_vm_template         | Name of the template to use (cf. prereqs)        |
| manageiq_vm_ovirt_cluster    | Name of the oVirt cluster where to deploy the VM |
| manageiq_vm_name             | Name of the VM                                   |
| manageiq_vm_cpus             | Number of vCPUs to allocate to the VM            |
| manageiq_vm_memory_gb        | Amount of memory to allocate to the VM in GB     |
| manageiq_vm_ip_address       | IP address of the VM                             |
| manageiq_vm_netmask          | Netmask of the VM                                |
| manageiq_vm_subnet_prefix    | Subnet prefix of the VM                          |
| manageiq_vm_gateway          | Gateway of the VM                                |
| manageiq_vm_dns_servers      | DNS servers                                      |
| manageiq_vm_dns_domain       | DNS domain                                       |
| manageiq_vm_disks_postgresql | Disk on which PostgreSQL stores its data         |
| manageiq_vm_disks_logs       | Disk on which ManageIQ logs are stored           |
| manageiq_vm_root_password    | Root password of the VM (consider Ansible Vault) |

[config/ovirt_auth.example.yml](../blob/master/config/ovirt_auth.example.yml)

| Variable           | Description                        |
| ------------------ | ---------------------------------- |
| ovirt_api_endpoint | Base URL of the oVirt API endpoint |
| ovirt_api_username | Username to connect to oVirt API   |
| ovirt_api_password | Password to connect to oVirt API   |

[config/rhel_custom_repos.example.yml](../blob/master/config/rhel_custom_repos.example.yml)
There's only one variable `rhel_custom_repos`, so take a look at the example.


The playbook that creates the VM generates the inventory and sets default
variables. However, it is possible to override these defaults, when running
the `manageiq_install.yml` playbook on a virtual machine deployed separately.
The `inventory.example.yml` file shows the options one can set.

| Variable           | Description                                           |
| ------------------ | ----------------------------------------------------- |
| manageiq_postgresql_version | PostgreSQL version to use (default: 9.5)     |
| manageiq_ruby_version       | Ruby version to use (default: 2.4)           |
| manageiq_postgresql_disk    | Disk on which PostgreSQL stores its data     |
| manageiq_postgresql_vg_name | Name of the volume group for PostgreSQL      |
| manageiq_postgresql_lv_name | Name of the logical volume for PostgreSQL    |
| manageiq_logs_disk          | Disk on which ManageIQ logs are stored       |
| manageiq_logs_vg_name       | Name of the volume group for ManageIQ logs   |
| manageiq_logs_lv_name       | Name of the logical volume for ManageIQ logs |

Apart from the disks, you shouldn't have to set these options.
