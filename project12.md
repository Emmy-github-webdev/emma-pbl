##  Project 12 Ansible Refactoring, Assignments & Imports

[For better understanding or Ansible artifacts re-use](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html)

 > Use [project 11](https://github.com/Emmy-github-webdev/emma-pbl/blob/main/project11.md) infrastructure as a continuation of project 12.

> Step 1– Jenkins job enhancement
- Go to your Jenkins-Ansible server and create a new directory called _ansible-config-artifact_ – we will store there all artifacts after each build.

```
sudo mkdir /home/ubuntu/ansible-config-artifact
```

- Change permissions to this directory, so Jenkins could save files there 
```
sudo chmod 0777 /home/ubuntu/ansible-config-artifact
```

- Check the permission
```
ll

```

- Go to Jenkins web console -> Manage Jenkins -> Manage Plugins -> on Available tab search for Copy Artifact and install this plugin without restarting Jenkins

- Create a new Freestyle project (you have done it in Project 9) and name it save_artifacts.
- This project will be triggered by completion of your existing ansible project. Configure it accordingly:

  * Under General tab, select "Discard olf builds"
  * A new input form will be open, add tha max # of builds to keep
  Under build triggers, select "Build after other projects are built"
  * In the input form that open, enter project to watch. In tis case we use the "Ansible" in project 11.
  * Select trigger only if the build is stable
  * Under "Build" select ""Copy artifacts from another project
  * In the input form that open, enter the project name, in this case "Ansible"
  * In the artifact copy, type "**"
  * In the targer directory, enter the directory created above "home/ubuntu/ansible-config-artifact"

> Step 2 – Refactor Ansible code by importing other playbooks into site.yml

- Most Ansible users learn the one-file approach first. However, breaking tasks up into different files is an excellent way to organize complex sets of tasks and reuse them.
- Let see code re-use in action by importing other playbooks.
1. Within playbooks folder, create a new file and name it site.yml – This file will now be considered as an entry point into the entire infrastructure configuration. Other playbooks will be included here as a reference. In other words, site.yml will become a parent to all other playbooks that will be developed. Including common.yml that you created previously. Dont worry, you will understand more what this means shortly.

2. Create a new folder in root of the repository and name it static-assignments. The static-assignments folder is where all other children playbooks will be stored. This is merely for easy organization of your work. It is not an Ansible specific concept, therefore you can choose how you want to organize your work. You will see why the folder name has a prefix of static very soon. For now, just follow along.

3. Move common.yml file into the newly created static-assignments folder.

4. Inside site.yml file, import common.yml playbook.
```
---
- hosts: all
- import_playbook: ../static-assignments/common.yml

```

The code above uses built in [import_playbook](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/import_playbook_module.html) Ansible module.

- Your folder structure should look like this;

```
├── static-assignments
│   └── common.yml
├── inventory
    └── dev
    └── stage
    └── uat
    └── prod
└── playbooks
    └── site.yml
```
5. Run ansible-playbook command against the dev environment
> Since you need to apply some tasks to your dev servers and wireshark is already installed – you can go ahead and create another playbook under static-assignments and name it common-del.yml. In this playbook, configure deletion of wireshark utility.

```
---
- name: update web, nfs and db servers
  hosts: webservers, nfs, db
  remote_user: ec2-user
  become: yes
  become_user: root
  tasks:
  - name: delete wireshark
    yum:
      name: wireshark
      state: removed

- name: update LB server
  hosts: lb
  remote_user: ubuntu
  become: yes
  become_user: root
  tasks:
  - name: delete wireshark
    apt:
      name: wireshark-qt
      state: absent
      autoremove: yes
      purge: yes
      autoclean: yes

```

* update site.yml with - import_playbook: ../static-assignments/common-del.yml instead of common.yml and run it against dev servers:

```
cd /home/ubuntu/ansible-config-mgt/

ansible-playbook -i inventory/dev.yml playbooks/site.yaml

```
* Make sure that wireshark is deleted on all the servers by running wireshark --version

* Now you have learned how to use import_playbooks module and you have a ready solution to install/delete packages on multiple servers with just one command.