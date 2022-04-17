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

### Download common tools used for Jenkins
- Install the required tools maven, nunit, nuget, git using chocolatey which is software management automation for Windows 10
- Go to [chocolatey](https://chocolatey.org/)
- Click on download chocolatey now
- Open Powershell on Windows 10
- Run Get-ExecutionPolicy to check if it is restricted.
- If the executionPoilcy is restricted, run Set-ExecutionPolicy RemoteSigned
- Run Get-ExecutionPolicy to check if it has been removed.
- Copy the command to install chocolatey on the machine: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
- After installation is complete, go to the chocolatey page and click on packages
- On the search, type git
- Copy the choco command to install git and run on the pwershell
- Repaet the steps for all the tools

### Building project with maven

>Building project with Maven commandline interface (Manual)

- The github to use for this project is https://github.com/executeautomation

- For java, let us cucumberbasic repo: https://github.com/executeautomation/cucumberbasic
- clone the repo
- Open the project directory with command line and type: mvn
- Clean the project: mvn clean
- Compile the project: mvn compile
- At the completion of compilation: a "target" folder will be created containing the class file

> Creating and working with Freestyle project using Jenkins
- On the Jenkins portal, click create new job
- Add item name: BasicEAFreestyle
- Select a freestyle project
- Click okay to create the job for us
- Select Source code management
- Select git and add the repo url
- Select Build Environment tab
- Under Build, select "Invoke to-level Maven targets"
- In the Goals type: compile
- Save
- On the Jenkins page, select Build now
- If the build fails, restart your machine
- Rebuild again.
- Console output can help with logs to check error


### Creating Pipeline project using Jenkins
- In the Jenkins portal, create a new item E.g "SeleniumWithCucumberPipeline"
- Select pipeline and cliclk ok to create pipeline project
- Go back to the Jenkins portal and click the SeleniumWithCucumberPipeline
- Under Advanced Project Options tab, go to Pipeline part
- Under the pipeline, click Pipeline syntax
- In the syntax, select git in the sample step
- Add the clone url of https://github.com/executeautomation/SeleniumWithCucucumber in the Repository URL
- Click Generate pipeline script
- copy the script and let go back to the advanced project options
- Pipeline definition, select Pipeline script
- Paste the script syntax and to the script 
- Go back to the Pipeline syntax snipet
- If you do not see maven in the sample step, select windows batch script
- In the batch script, type mvn verify
- Generate Pipeline script and copy it to paste in the Pipeline script
- Go back to the Pipeline syntax snipet
- Select node Allocate node in the sample step
- In the label type: master
- Generate pipeline script and copy it to paste in the Pipeline script
- save
- Click build now

