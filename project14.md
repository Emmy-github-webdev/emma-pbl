## EXPERIENCE CONTINUOUS INTEGRATION WITH JENKINS | ANSIBLE | ARTIFACTORY | SONARQUBE | PHP
_Executable file_ is a file created by a building stage of a compiled programming languages. Example are >Net, Java(.jar). The executable file contains the neccessary dependencies, all the code embedded, which application needs to run and work successfully.

<br>

Some other programming languages such as **PHP**, **Javascript**, or **Python** work differently without being built into an executable file. _This languages are called interpreteed_. We can package the entire code and all it's dependencies into an archive such as **.tar**, **.gz**, or **.zip**, so that it can be easily unpacked on a respective environment servers.

### [Difference between compiled VS interpreted programming languages](https://www.freecodecamp.org/news/compiled-versus-interpreted-languages/)

<br>

In a compiled language, the target machine directly translates the program. In an interpreted language, the source code is not directly translated by the target machine. Instead, a different program known as interpreter, reads, and execute the code.

### What is Continuous Integration?

CI is a practice of merging all developers's working copies to a shared mainline (e.g Git Repository or some other version) per day.

_Artifact:_ is the by-product produced during the software development process. It  may consist of the project sources code, dependencies, binaries or resources, and could be presented in different layout depending on the technology. Artifacts are usualy stored in a repository like jFrog Artifactory,.

#### Continuous Integration in The Real World

_To emphasize a typical CI Pipeline further, let us explore the diagram below a little deeper._

![](images/project14/ci-pipeline-regular.png)

- **Version Control**: This is the stage where developers’ code gets committed and pushed after they have tested their work locally.
- **Build**: Depending on the type of language or technology used, we may need to build the codes into binary executable files (in case of compiled languages) or just package the codes together with all necessary dependencies into a deployable package (in case of interpreted languages).
- **Unit Test**: Unit tests that have been developed by the developers are tested. Depending on how the CI job is configured, the entire pipeline may fail if part of the tests fails, and developers will have to fix this failure before starting the pipeline again. A Job by the way, is a phase in the pipeline. Unit Test is a phase, therefore it can be considered a job on its own.
- **Deploy**: Once the tests are passed, the next phase is to deploy the compiled or packaged code into an artifact repository. This is where all the various versions of code including the latest will be stored. The CI tool will have to pick up the code from this location to proceed with the remaining parts of the pipeline.
- **Auto Test**: Apart from Unit testing, there are many other kinds of tests that are required to analyse the quality of code and determine how vulnerable the software will be to external or internal attacks. These tests must be automated, and there can be multiple environments created to fulfil different test requirements. For example, a server dedicated for Integration Testing will have the code deployed there to conduct integration tests. Once that passes, there can be other sub-layers in the testing phase in which the code will be deployed to, so as to conduct further tests. Such are User Acceptance Testing (UAT), and another can be Penetration Testing. These servers will be named according to what they have been designed to do in those environments. A UAT server is generally be used for UAT, SIT server is for Systems Integration Testing, PEN Server is for Penetration Testing and they can be named whatever the naming style or convention in which the team is used. An environment does not necessarily have to reside on one single server. In most cases it might be a stack as you have defined in your Ansible Inventory. All the servers in the inventory/dev are considered as Dev Environment. The same goes for inventory/stage (Staging Environment) inventory/preprod (Pre-production environment), inventory/prod (Production environment), etc. So, it is all down to naming convention as agreed and used company or team wide.
- **Deploy to production**: Once all the tests have been conducted and either the release manager or whoever has the authority to authorize the release to the production server is happy, he gives green light to hit the deploy button to ship the release to production environment. This is an Ideal Continuous Delivery Pipeline. If the entire pipeline was automated and no human is required to manually give the Go decision, then this would be considered as Continuous Deployment. Because the cycle will be repeated, and every time there is a code commit and push, it causes the pipeline to trigger, and the loop continues over and over again.
- **Measure and Validate**: This is where live users are interacting with the application and feedback is being collected for further improvements and bug fixes. There are many metrics that must be determined and observed here. We will quickly go through 13 metrics that MUST be considered.

#### Common Best Practices of CI/CD
_Before we move on to observability metrics – let us list down the principles that define a reliable and robust CI/CD pipeline:_

- Maintain a code repository
- Automate build process
- Make builds self-tested
- Everyone commits to the baseline every day
- Every commit to baseline should be built
- Every bug-fix commit should come with a test case
- Keep the build fast
- Test in a clone of production environment
- Make it easy to get the latest deliverables
- Everyone can see the results of the latest build
- Automate deployment (if you are confident enough in your CI/CD pipeline and willing to go for a fully automated Continuous Deployment)
