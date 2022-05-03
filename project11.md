## ANSIBLE CONFIGURATION MANAGEMENT – AUTOMATE PROJECT 7 TO 10

[Resources](https://www.youtube.com/watch?v=uuhhOhWTrrs)

> Task
- Install and configure Ansible client to act as a Jump Server/Bastion Host
- Create a simple Ansible playbook to automate servers configuration
- Update Name tag on your Jenkins EC2 Instance to Jenkins-Ansible. We will use this server to run playbooks

 ![](images/project11/web-server-reachable.png)

 > STEP 1 - INSTALL AND CONFIGURE ANSIBLE ON EC2 INSTANCE

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

- Configure webhook to communicatw with Jenkins whenever changes are made
    * In the GitHub repo, go to the settings
    * Click Webhooks
    * Click add webhook
    * In the payload URL, add the Jenkins URL: https://x.x.x.x:8080/github-webhook/
    * In content type, select ""application/json
    * Under "Which events would you like to trigger webhook", select"Just the push event"
    * Leave active checked
    * Click Add

- Configure Jenkins build job to save your repository content every time you change it
    * Create a new Freestyle project ansible in Jenkins
    * Go to the "Source Code Management of the Ansible freestyle"
    * Select Git
    * Copy the Git repo URL for ansible-config-mgt and paste in the Repository URL
    * Select type the branch name
    * Under Build Triggers, select "GitHub hook trigger for GITScm polling"
    * Under "Post-build Actions", select "Archive the artifacts"
    * In the File to archive type two stars " ** "
    * click on Save
    * Go back to the Ansible freestyle project and click on "Build now"
- Test your setup by making some change in README.MD file in master branch and make sure that builds starts automatically and Jenkins saves the files (build artifacts) in following folder
```
ls /var/lib/jenkins/jobs/ansible/builds
```
* It should display the number of builds

```
ls /var/lib/jenkins/jobs/ansible/builds/<build_number>/archive/
```
* It should display the file that changes were made. For this case is README.md
* To view the content of the file 

```
cd /var/lib/jenkins/jobs/ansible/builds/<build_number>/archive/
cat the_file_name e.g cat README.md
exit
```

> Step 2 – Prepare your development environment using Visual Studio Code
- Download and Install VS code
- Install Remote development extension
- Clone the ansible-config-mgt repo

> Step 3 - BEGIN ANSIBLE DEVELOPMENT
- In the ansible-config-mgt GitHub repository, create a new branch that will be used for development of a new feature.
    * Tip: Give your branches descriptive and comprehensive names, for example, if you use Jira or Trello as a project management tool – include ticket number (e.g. PRJ-145) in the name of your branch and add a topic and a brief description what this branch is about – a bugfix, hotfix, feature, release (e.g. feature/prj-145-lvm)
- Checkout the newly created feature branch to your local machine and start building your code and directory structure
- Create a directory (folder) and name it playbooks – it will be used to store all your playbook files.
- Create a directory (folder) and name it inventory – it will be used to keep your hosts organised.
- Within the playbooks folder, create your first playbook, and name it common.yml
- Within the inventory folder, create an inventory file (.yml) for each environment (Development, Staging Testing and Production) dev, staging, uat, and prod respectively.

