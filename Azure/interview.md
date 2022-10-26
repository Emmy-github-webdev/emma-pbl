[Resource 1](https://www.youtube.com/watch?v=w3jCpzhMZNc)

1. We have 50 commits in Develop branch and out of which only 5 commits needs to be pushed in Release branch (Which will eventually deployed in production)
 Ans: Git cherry-picking: cherry-picking is the act of picking a commit from a branch and applying it to anothet (git cherry-picking commitSha).


2. Developer (RAM) has developed an application module and while developing he has made around 100 commits locally, now he needs to push all his changes in remote Develop branch as a single commit (We don't want developers messy history in Develop branch)

Ans: Git squash. Git squash is a technique that helps you to take a series of commits and condense it to a few commits. (git rebase -i HEAD~3) 

3. Developer (RAM) has few uncommit changes in his local branch and now he has to empty his current work directory to accommodate emergency change (ECR, Bug fix). How can RAM handle such scenario without losing his uncommit changes?

Ans: Git stash. Git stash command takes your uncommited changes (both staged and upstaged), saves them away for later use, and then revert them from your working copy.

- git stash(Stashes uncommit changes)
- git stash list (To list all stashed changes)
- git stash pop (To re-apply the most stash changes)
- git stash drop (To drop the most recent stash changes)

4. Developer (RAM) has packaged and pushed his project module in Azure Artifacts and now developer (Lakshman) project consume packages from Azure Artifacts locally to successfully build project?

5. Developer (RAM) has create a ASP.NET Core application and now he wish to automate the entire build and release process through Azure DevOPs, Guide the developer with the entire end to end process and deploy the application on Azure WebApp using Iac methodology.

Ans: 
- First steps taken by developer to build the application locally.
- Create Azure Repos and push the source code in remote repository along with IaC configuration files
- Create a build pipelines Classic or YAML based
	- Build the solution using MS-build or VS-build
	- Run code analysis through SonarQube, 
	- Run code coverage
	- Copy ARM or Terraform configuration files
	- publish the artifacts etiher on File Share or Azure Pipeline drop location.
- Use ARM template or Terraform configuration to create an Azure WebApp
- Create release pipeline, run the ARM template task
- Post WebApp creation run ASP.NET application deployment task.

6. Developer (Laksman) has a micro-service application (ASP.NET Core), automate the entire end to end process to deploy the application on AKS (Azure Kubernetes Services). Make sure to use PAC (Pipeline as a code) methodology for entire build and release.

Ans:
- Pre-requisites
- Create Azure Kubernetes Service (AKS) cluster 
- Create Azure Container Registry (Azure Container Registry)
- Service Connection to connect to Azure Cloud Service.
- Create Azure Repos and push the source code in remote repository along withmultiple configuration files such as Dockerfile, Deployment.yaml, Service.yaml files
- Create a build and release pipeline using YAML (azure-pipelines.yaml)
- Build
  - The solution will be build based on the steps mentioned in Dockerfile
	- Along with it we can run code analysis and code coverage
	- Once the solution is build it will be pushed in ACR
	- Publish the manifest file either on file share or Azure Pipeline drop location
- Deploy
	- First the image will be pulled from ACR 
	- post that through manifests file the deploment will be tiggered in AKS cluster
