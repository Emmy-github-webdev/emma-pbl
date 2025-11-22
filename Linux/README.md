# Linux

## Vagrant for VM
In vagrant there is no OS installation. It comes with a free box available on Vagrant could.

- _Vagrantfile_ - It manage all the VM settings, VM changes, provisioning
- _Vagrant commands_
- vagrant init boxname
- vagrant status
- vagrant list
- vagrant ssh - to login
- vagrant up
- vagrant ssh
- vagrant halt
- vagrant destroy
- vagrant reload
- history - To view prevous issued command
- vagrant global-status - Tell the state of all active Vagrant environments on the system for the currently logged in user.

#### Vagrant Architecture

![](../images/linux/vagrant-architecture.jpg)

- _Steps to setup VM using vigrant_
1. Create a folder in the directory of your choice: mkdir /c/vagrant-vms
2. Create vagrant file - vagrant init boxname. for example (vagrant init eurolinux-vagrant/centos-stream-9)
3. Start the VM using: vagrant up


