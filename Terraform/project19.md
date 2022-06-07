# Automate Infrastructure With IaC using Terraform. Part 4 – Terraform Cloud

_What Terraform Cloud is and why use it_

[Terraform Cloud](https://cloud.hashicorp.com/products/terraform) is a managed service that provides you with Terraform CLI to provision infrastructure, either on demand or in response to various events.

> #### Migrate your .tf codes to Terraform Cloud
Le us explore how we can migrate our codes to Terraform Cloud and manage our AWS infrastructure from there:

1. Create a Terraform Cloud account. Follow [this link](https://app.terraform.io/signup/account), create a new account, verify your email and you are ready to start
<br>

Most of the features are free, but if you want to explore the difference between free and paid plans – you can check it on [this page](https://www.hashicorp.com/products/terraform/pricing)

2. Create an organization - Select "Start from scratch", choose a name for your organization and create it.

3. Configure a workspace - Before we begin to configure our workspace – watch [this part of the video](https://www.youtube.com/watch?v=m3PlM4erixY&t=287s) to better understand the difference between _version control workflow_, _CLI-driven workflow_ and _API-driven workflow_ and other configurations that we are going to implement.

<br>

We will use _version control workflow_ as the most common and recommended way to run Terraform commands triggered from our git repository.

<br>

Create a new repository in your GitHub and call it _terraform-cloud_, push your Terraform codes developed in the previous projects to the repository.

<br>

Choose _version control workflow_ and you will be promped to connect your GitHub account to your workspace – follow the prompt and add your newly created repository to the workspace.

<br>

Move on to "Configure settings", provide a description for your workspace and leave all the rest settings default, click "Create workspace".