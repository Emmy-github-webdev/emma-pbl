## TOOLING WEBSITE DEPLOYMENT AUTOMATION WITH CONTINUOUS INTEGRATION. INTRODUCTION TO JENKINS

[CI](https://circleci.com/continuous-integration/)

- In this project we are going to start automating part of our routine tasks with a free and open source automation server – Jenkins. It is one of the mostl popular CI/CD tools, it was created by a former Sun Microsystems developer Kohsuke Kawaguchi and the project originally had a named "Hudson".
- Acording to Circle CI, Continuous integration (CI) is a software development strategy that increases the speed of development while ensuring the quality of the code that teams deploy.

> Task
- Enhance the architecture prepared in Project 8 by adding a Jenkins server, configure a job to automatically deploy source codes changes from Git to NFS server.

Here is how your updated architecture will look like upon competion of this project:

![](images/project9/arch.png)

### Install and Configure Jenkins server

> Step 1 - Install Jenkins Server
1. Create an AWS EC2 server based on Ubuntu server 20.04 LTS and name it "Jenkins" with TCP port 8080 open in the inbound rule
2. Install[JDK](https://en.wikipedia.org/wiki/Java_Development_Kit)
   ```
    sudo apt update
    sudo apt install default-jdk-headless

   ```
3. Install Jenkins
    ```
        wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
        sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
        sudo apt-get update
        sudo apt-get install jenkins
    ```
4. Verify jenkins is up and runningh
    ```
        sudo systemctl status jenkins
    ```
    ![](images/project9/jenkins-status.png)
5. Perform Iniatial Jenkins Setup
    * From browser, access http://Jenkins-Server-Public-IP-Address-or-Public-DNS-Name:8080

    ![](images/project9/unlock-page.png)

    * Retrieve the adminstrator password from your server: sudo cat /var/lib/jenkins/secrets/initialAdminPassword

      ![](images/project9/admin-password.png)

    * Enter the password in the administrator page above and click continue

    ![](images/project9/after-admin-login.png)

    * Click Install suggested plugins
    * Create admin account after plugins installation is completed

      ![](images/project9/create-new-acct.png)

    * Jenkins URL - http://34.229.141.79:8080/

    ![](images/project9/jenkins-url.png)

    * save and continue

     ![](images/project9/finish.png)

> Step 2 – Configure Jenkins to retrieve source codes from GitHub using Webhooks
- We will configure a simple Jenkins job/project that will be triggered by GitHub [webhooks](https://en.wikipedia.org/wiki/Webhook) and will execute a ‘build’ task to retrieve codes from GitHub and store it locally on Jenkins server.
- Enable webhooks in your GitHub repository settings
    * Click the repo and set the webhook settings below

     ![](images/project9/webhook.png)

    * Go to Jenkins web console, click "New Item" and create a "Freestyle project"

    ![](images/project9/new-item.png)

- To connect your GitHub repository, you will need to provide its URL, you can copy from the repository itself

 ![](images/project9/github-url.png)

 - In configuration of your Jenkins freestyle project choose Git repository, provide there the link to your Tooling GitHub repository and credentials (user/password) so Jenkins could access files in the repository.

 ![](images/project9/add-github-link.png)

 - Click on build now

     ![](images/project9/build.png)

 - Click "Configure" your job/project and add these
    * Configure triggering the job from GitHub webhook
    * Configure "Post-build Actions" to archive all the files – files resulted from a build are called "artifacts"

        ![](images/project9/post-build.png)
-  Make some change in any file in the GitHub repository (e.g. README.MD file) and push the changes to the master branch.

- You will see that a new build has been launched automatically (by webhook) and you can see its results – artifacts, saved on Jenkins server.

![](images/project9/readme-change.png)

> Note: You have now configured an automated Jenkins job that receives files from GitHub by webhook trigger (this method is considered as ‘push’ because the changes are being ‘pushed’ and files transfer is initiated by GitHub). There are also other methods: trigger one job (downstreadm) from another (upstream), poll GitHub periodically and others. By default, the artifacts are stored on Jenkins server locally
```
    ls /var/lib/jenkins/jobs/tooling_github/builds/<build_number>/archive/

```


