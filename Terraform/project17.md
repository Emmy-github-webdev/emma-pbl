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

##### A little bit more about Tagging

_Tagging is a straightforward, but a very powerful concept that helps you manage your resources much more efficiently:_

- Resources are much better organized in ‘virtual’ groups
- They can be easily filtered and searched from console or programmatically
- Billing team can easily generate reports and determine how much each part of infrastructure costs how much (by department, by type, by environment, etc.)
- You can easily determine resources that are not being used and take actions accordingly
- If there are different teams in the organisation using the same account, tagging can help differentiate who owns which resources.

**Note**: You can add multiple tags as a default set. for example, in out terraform.tfvars file we can have default tags defined.

<br>

_main.tf_

```
# Create public subnets
resource "aws_subnet" "public" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.tags,
    {
      Name = format("%s-publicSubnet-%s", var.name, count.index)
    },
  )
}
```

```
# Create private subnets
resource "aws_subnet" "private" {
  count  = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + 2)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(
  var.tags,
    {
      Name = format("%s-privatesubnet-%s", var.name, count.index)
    },
  )

}
```

_variables.tf_

```
variable "name" {
  type = string
  default = "ACS"
}
```

```
variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type = map(string)
  default = {}
}
```
_terraform.tfvars_

```
tags = {
  Enviroment      = "production" 
  Owner-Email = "ogaemmanuel@ymail.com"
  Managed-By = "Terraform"
  Billing-Account = "1234567890"
}
```

_run_

```
terraform plan
```
The nice thing about this is – anytime we need to make a change to the tags, we simply do that in one single place (***terraform.tfvars***).

> #### Internet Gateways & format() function

Create an Internet Gateway in a separate Terraform file **internet_gateway.tf**

_internet_gateway.tf_

```
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-%s!", var.name, aws_vpc.main.id, "IG")
    },
  )
}
```

Did you notice how we have used **format()** function to dynamically generate a unique name for this resource? The first part of the **%s** takes the interpolated value of **aws_vpc.main.id** while the second **%s** appends a literal string **IG** and finally an exclamation mark is added in the end.

<br>

If any of the resources being created is either using the **count** function, or creating multiple resources using a loop, then a key-value pair that needs to be unique must be handled differently.

<br>

For example, each of our subnets should have a unique name in the tag section. Without the **format()** function, we would not be able to see uniqueness. With the **format** function, each private subnet’s tag will look like this.

> #### NAT Gateways

Create 1 NAT Gateways and 1 Elastic IP (EIP) addresses

<br>

Now use similar approach to create the NAT Gateways in a new file called **natgateway.tf**.

_natgateway.tf_

```
# Create aws elastic IP

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]

  tags = merge(
    var.tags,
    {
      Name = format("%s-EIP-%s", var.name, var.environment)
    },
  )
}

# Create aws nat gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = merge(
    var.tags,
    {
      Name = format("%s-Nat-%s", var.name, var.environment)
    },
  )
}
```

_variables.tf_

```
variable "environment" {
  type = string
  description = "Environment"
}
```

_terraform.tfvars_

```
environment = "dev"

```

_run_

```
terraform plan
```

> #### AWS ROUTES

Create a file called ***route_tables.tf** and use it to create routes for both public and private subnets, create the below resources. Ensure they are properly tagged.

1. aws_route_table
2. aws_route
3. aws_route_table_association

_route_tables.tf_

```
# create private route table
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-Private-Route-Table-%s", var.name, var.environment)
    },
  )
}

# create route for the private route table and attach the nat gateway to it
resource "aws_route" "private-rtb-route" {
  route_table_id         = aws_route_table.private-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}

# associate all private subnets to the private route table
resource "aws_route_table_association" "private-subnets-assoc" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private-rtb.id
}

# create route table for the public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-Public-Route-Table-%s", var.name, var.environment)
    },
  )
}

# create route for the public route table and attach the internet gateway
resource "aws_route" "public-rtb-route" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# associate all public subnets to the public route table
resource "aws_route_table_association" "public-subnets-assoc" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public-rtb.id
}
```

_run_

```
terraform plan
```