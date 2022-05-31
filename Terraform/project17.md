# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 2

> #### Networking

_Private subnets & best practices_

<br>

Create 4 private subnets keeping in mind following principles:

- Make sure you use variables or **length()** function to determine the number of AZs
- Use variables and **cidrsubnet()** function to allocate **vpc_cidr** for subnets
- Keep variables and resources in separate files for better code structure and readability


_main.tf_

```
# Create private subnets
resource "aws_subnet" "private" {
  count  = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + 2)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

}
```

_variables.tf_

```
variable "preferred_number_of_private_subnets" {
  default = null
  type = number
  description = "Number of private subnets"
}
```

_terraform.tfvars_

```
preferred_number_of_private_subnets = 4
```

_run_

```
terraform init

terraform plan

```
- Tags all the resources you have created so far. Explore how to use **format()** and **count** functions to automatically tag subnets with its respective number.
