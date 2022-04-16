## Jenkins
- Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks such as building, testing, and deploying software.

### Is Jenkins is like TFS?
- Well, yes in many ways, since jenkins is a continuous integration tools, but still lacks many other areas where TFS (Team Foundation Server) is much more broader than jenkins, since TFS is more of a 
> Version Control System
> Requirement Management System
> Project Management System
> Automated build management system
> Testing and release management system
> All, the above is otherwise called as Application Lifecycle Management System

### Software Pre-requisite

- We need the following softwares installed before getting started with jenkins 2.0
> JAVA (latest is good)
> Jenkins war file
- Supporting Tools
> Maven
> Nunit
> Nuget
> Git

### Install Jenkins
- Go to https://jenkins.io to download jenkins [Step by Step](https://www.jenkins.io/doc/book/installing/)
- Install [JAVA](https://java.com/en/download/windows_manual.jsp), [Step by Step](https://phoenixnap.com/kb/install-java-windows)
- Go to the location Jenkins.war was downloaded and open with commad prompt
- Type: > Java -jar jenkins.war
- Press enter key
- Note: there will be a password generated for you during the installation. Copy the password and save it for future use.
- On the browser type: localhost:8080 to start the jenkins
On the getting started page, unlock jenkins with the password copied from the step above
- Click continue and select install plugins
- When installation is completed, refresh the page
- Fill create first admin user page
- Save and finish

### Configure Jenkins for Build + Deploy + Test
> Click on Manage Jenkins 
- Select Configure global security
- Set it as you desire
- Go back to Manage jinkins and select Global Tool Configuration
- Set it as you desire
- Go back to Manage jinkins and select Configure System



