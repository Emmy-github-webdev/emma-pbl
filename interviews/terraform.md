# Terraform

1. Explain the end-user workflow steps for Terraform

- _Write-_ where engineers makes changes to code
- _Init-_ where they initialize the code for downloading requirements
- _Plan-_ where they review any changes and select whether to accept them
- _Apply-_ where they accept changes and apply them to the infrastructure

2. Name a couple of advantages of a Terraform state

- It enables Terraform to map resources to the engineer’s configuration
- It helps engineers monitor metadata
- Terraform state can enhance performances

3. Explain what providers are in Terraform

Providers are Terraform plugins. Providers permit Terraform to sync with Software as a Service provider, application programming interfaces, and cloud providers

4. Explain what Terraform backend refers to

Terraform backend refers to a platform where engineers store state snapshots

5. Explain the main Terraform features

- A console that enables function observation for users
- A feature for HCL code translation to JSON
- A configuration language feature that permits interpolation
- A feature for module tracking, which monitors the number of modules of the infrastructure

6. Explain why Terraform is handy for DevOps teams

Since Terraform functions with a configuration language similar to JSON (referred to as HashiCorp Configuration Language), its simple syntax makes it easy to use, and can implement these configurations for various clouds and data centers

7. Which method would you use to import existing resources in Terraform?

 Terraform import

8. Which method would you use to upgrade Terraform plugins?

terraform init