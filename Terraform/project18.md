# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 3 – REFACTORING

Introducing Backend on [S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

<br>

Each Terraform configuration can specify a backend, which defines where and how operations are performed, where state snapshots are stored, etc.
Take a peek into what the states file looks like. It is basically where terraform stores all the state of the infrastructure in **json** format.

<br>

So far, we have been using the default backend, which is the **local backend** – it requires no configuration, and the states file is stored locally. This mode can be suitable for learning purposes, but it is not a robust solution, so it is better to store it in some more reliable and durable storage.

<br>

The second problem with storing this file locally is that, in a team of multiple DevOps engineers, other engineers will not have access to a state file stored locally on your computer.

<br>

To solve this, we will need to configure a backend where the state file can be accessed remotely other DevOps team members. There are plenty of different standard backends supported by Terraform that you can choose from. Since we are already using AWS – we can choose an [S3 bucket as a backend](https://www.terraform.io/language/settings/backends/s3).

<br>

Another useful option that is supported by S3 backend is [State Locking](https://www.terraform.io/language/state/locking) – it is used to lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state. State Locking feature for S3 backend is optional and requires another AWS service – [DynamoDB](https://aws.amazon.com/dynamodb/).

_Here is our plan to Re-initialize Terraform to use S3 backend:_

1. Add S3 and DynamoDB resource blocks before deleting the local state file
2. Update terraform block to introduce backend and locking
3. Re-initialize terraform
4. Delete the local **tfstate** file and check the one in S3 bucket
5. Add **outputs**
6. **terraform apply**

##### Create a new folder _modules_

_New folder structure_

![](images/project18/folder-structure.png)

_Details of restucrured code and folder, see the repo for [project18](https://github.com/Emmy-github-webdev/pbl-terraform/tree/prj-18)_

###### Run the following commands to create the resources

```
# Check the validity of the code should there be any error
terraform validate

# Check terraform plan
terraform plan

# create tha plans
terraform apply --auto-approve
```

![](images/project18/1-appy-plans.png)

###### See the resources created below

_EC2 Instance_

![](images/project18/ec2-instances)

_Security group_

![](images/project18/security-group)

_Elastic IP_

![](images/project18/elastic-ip)

_Load balancer_

![](images/project18/loadbalancer)

_Target group_

![](images/project18/target-group)

_Auto scaling_

![](images/project18/autoscaling)

_Tags_

![](images/project18/tags)
