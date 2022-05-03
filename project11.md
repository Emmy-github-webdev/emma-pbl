## ANSIBLE CONFIGURATION MANAGEMENT – AUTOMATE PROJECT 7 TO 10

[Resources](https://www.youtube.com/watch?v=uuhhOhWTrrs)

> Task
- Install and configure Ansible client to act as a Jump Server/Bastion Host
- Create a simple Ansible playbook to automate servers configuration
- Update Name tag on your Jenkins EC2 Instance to Jenkins-Ansible. We will use this server to run playbooks

 ![](images/project11/web-server-reachable.png)

 > INSTALL AND CONFIGURE ANSIBLE ON EC2 INSTANCE

 - In your GitHub account create a new repository and name it ansible-config-mgt.

  ![](images/project11/web-server-reachable.png)

- Instal Ansible
```
 sudo apt update

 sudo apt install ansible
```

- Check Ansible version
```
ansible --version
```