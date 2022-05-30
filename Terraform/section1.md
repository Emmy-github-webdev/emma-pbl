# Introduction and prerequisites

[Resources](https://github.com/derekm1215/mtc-terraform)

> Adding security to your AWS account

- On the AWS Console, search for **IAM** to open IAM management console
- You could add MFA for root user
- **Add new user**
  * On the **IAM** console, click **Users**
  * Click **Add user**
  * Add user name 
  * Select AWS access type: Select either of the options
  * next
  * On set permission, click **Create a new group**
  * Add the group name - **admin**
  * Give the group **AddministratorAccess**
  * Add group
  * Next
  * on Tag, click next
  * Click review
  * Click create user


> ## Install Terraform
- Follow the step in the documentation [Install Terraform](https://learn.hashicorpext.com/tutorials/terraform/install-cli)

