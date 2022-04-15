# Ansible

- Ansible is a popular IT automation engine that automates task that are either cubersome or repetitive or complex like configuration managment, clould provisioning, software deployment, and intra-service orchestration.
> Benefits of Ansible in DevOps is to response and scale in pace with the demand.

> Do we need Ansible? Why
- Ansible is very useful and you would appreciate it with the example when there are 4 or 5 web servers to be configured and deployed, and when there are more than 4 database servers to be configured and deployed. There are applications in the web servers and it connects the database servers at the backend. Now the traditional situation demands that you separately configure these servers and manage them.

- However, these servers will have various application updates. Even a system admin cannot handle if there are more servers and their configurations will not be identical. These tasks are complex to do and to manage the number of servers without putting a lot of effort into system admin as well as by developers who are developing the applications. Just imagine other servers which the organization has such as DNS, NTP, AD, Email, etc 

- This is where Ansible comes into the picture. Infrastructure automation and orchestrations can be done by Ansible. All the similar servers can be handled and managed in one go by Ansible.

> Setup Lab

- Create three Machines (Using RedHat on AWS EC2 Instances): Ansible-controller, Ansible-target-1, Ansible-target-2
- Connect to your vms using SSH
- Rename the hostname: sudo vi /etc/hostname
- In the open file, type the name you want to give the host. Eg Ansible-controller. 
- Another place to modify is /etc/host file:  sudo vi /etc/hosts
- Edit the host name eg: Ansible-controller

![](images/ansible/change-hostname.png)

- Restart your system: shutdown now -r
- Repeat the same step for Ansible-target-1, Ansible-target-2

> Install Ansible on the Ansible-controller
- sudo yum install python3-pip
- sudo pip3 install ansible
- Verify that Ansible is installed: ansible --version

> Ansible Inventory

Ansible is agentless because it can connect to multiple servers using SSH for linux and powershell for Windows. Ansible can start managing remote machines immediately without any agent software installed.

- The information about this target systems are stored in the inventory file. If you do not create inventory file, Ansible will store it in the default location /etc/ansible/hosts 
### Inventroy parameters are
* ansible_host - To specify the Address of the server
* ansible_connection - ssh/winrm/localhost
* ansible_port - 22/5986
* ansible_user - root/administrator
* ansible_ssh_pass - Password
* Example: 
- web ansible_host=server1.example.com ansible_connection=ssh ansible_user=root
- db ansible_host=server2.example.com ansible_connection=winrm ansible_user=admin
- mail ansible_host=server3.example.com ansible_connection=ssh ansible_user=p@#
- web2 ansible_host=server4.example.com ansible_connection=winrm

> Demo - Ansible Inventory
### Test connectivity 
- Ansible-controller> ssh target_server_IP address
### Test connectivity to Ansible
- Ansible-controller> create a folder called "test-project"
- Ansible-controller> cd test-project
- Ansible-controller test-project> cat > inventory.txt Ansible-target-1 ansible_host=Ansible-target-1IP_address ansibl_ssh_pass=password
- Ansible-controller test-project> cat  inventory.txt - To read the inventory fie
- Ansible-controller test-project> ansible Ansible-target-1 -m ping -1 inventory.txt - To ping ansible on the target machine and verify the ansible controller can communitace with terget machine

### Modify inventory file
- Ansible-controller test-project> vi inventory.txt
-   Add information about target 2 as shown below
- Ansible-target-2 ansible_host=Ansible-target-1IP_address ansibl_ssh_pass=password
- save
### Test ping to Ansible-target-2 
- Ansible-controller test-project> cat > inventory.txt Ansible-target-2 ansible_host=Ansible-target-1IP_address ansibl_ssh_pass=password
- Ansible-controller test-project> cat  inventory.txt - To read the inventory fie
- Ansible-controller test-project> ansible Ansible-target-2 -m ping -1 inventory.txt - To ping ansible on the target machine and verify the ansible controller can communitace with terget machine

