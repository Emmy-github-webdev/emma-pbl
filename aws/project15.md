

> SET UP A VIRTUAL PRIVATE NETWORK (VPC)

1. Create a [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) 
  - name - asc-vpc
  - ipv4 CIDR block - 10.0.0.0/16
  - click ceate
2. Edit DNS hostname
   - Click pn action from the VPC created and select "Edit DNS hostname"
   - Click enable
   - Save changes
3. Create [Internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
  - Under the **Virtual Private Cloud** click internet gateway
  - Click internet gateway
  - name - ACS-igw
  - Click create internet gateway
  - Click on attach to a VPC
  - Select the VPC created above 
  - Click attached
4. Create a route table and associate it with public subnets
- Use [IP Info to create subnet](https://ipinfo.io/ips)
- Click on 10.0.0.0/8
- Click on 10.0.0.0/16
- Note for safty: Set even numbers of the ip address to public network, old numbers to private network
_Public Network_
- Under the **Virtual Private Cloud** click subnet
- create subnet
- Select the vpc we created
- subnet - "ASC-public-subnet-1"
- Availability zone - "US East 1a"
- IPV4 CIDR bloc - 10.0.0.0/24
- Click **Add new subnet** to add the second public subnet 
subnet - "ASC-public-subnet-2"
- Availability zone - "US East 1b"
- IPV4 CIDR bloc - 10.0.2.0/24
- Click create subnet
_Private Network_
- Click create subnet
- subnet - "ASC-private-subnet-1"
- Availability zone - "US East 1a"
- IPV4 CIDR bloc - 10.0.1.0/24
- Click **Add new subnet** to add the second private subnet 
subnet - "ASC-private-subnet-2"
- Availability zone - "US East 1b"
- IPV4 CIDR bloc - 10.0.3.0/24
- Click **Add new subnet** to add the third private subnet 
subnet - "ASC-private-subnet-3"
- Availability zone - "US East 1a"
- IPV4 CIDR bloc - 10.0.5.0/24
- Click **Add new subnet** to add the fourth public subnet 
subnet - "ASC-private-subnet-4"
- Availability zone - "US East 1b"
- IPV4 CIDR bloc - 10.0.7.0/24
- Click
5. Create a route table and associate it with public, and private subnets
- Under the **Virtual Private Cloud** click Route tables
- Click round table
_public route table_
- name - "ASC-public-rtb"
- VPC - Select the vpc created
- click on create
_public route table_
- name - "ASC-private-rtb"
- VPC - Select the vpc created
- click on create
- click on the ACS-public-rtb
- click on subnet association tab
- edit subnet association
- Select all the public subnets
- click associate
_private route table_
- name - "ASC-public-rtb"
- VPC - Select the vpc created
- click on create
- click on the ACS-private-rtb
- click on subnet association tab
- edit subnet association
- Select all the private subnets
- click associate
6. Edit a route in public route table, and associate it with the Internet Gateway. (This is what allows a public subnet to be accisble from the Internet)
- Select the ASC-public-rtb
- On the action drop down, select edit route table
- click on add route
- Destination - 0.0.0.0/0
- Target - Internet gateway - Select the internet gateway created
- save
7. Create 3 [Elastic IPs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)

- Under the **Virtual Private Cloud** click elastic IP
- Click allocate elastic ip
- Under tags
- name - name
- value - asc-nat
- click allocate
- Under the **Virtual Private Cloud** Nat Gateway
- Create NAT gateway
- name - ACS-NAT-Gateway
- Subnet - Select public subnet 1 or 2
- Elastic IP allocation ID - Select the elastic Ip created "ACS-NAT"
- Create
- On the route table, Select the ASC-private-rtb
- On the action drop down, select edit route table
- click on add route
- Destination - 0.0.0.0/0
- Target - Internet gateway - Select the NAT Gateway created
- save
8. Create a Security Group
- Under the **Virtual Private Cloud** Security group
- click create security group
_for Application Load Balancer: ALB will be available from the Internet_
- security group name- ASC-ext-ALB
- VPC - select ACS-VPC
- Add rule
 * inbounds rules (http, https with port port 80, 443, and anywhere IP respectively)
- add tag
 * name - name
 * value - ASC-ext-ALB
 - create

 _for Bastion Servers: Access to the Bastion servers should be allowed only from workstations that need to SSH into the bastion servers. Hence, you can use your workstation public IP address. To get this information, simply go to your terminal and type curl www.canhazip.com_

 - security group name- ASC-bastion
- VPC - select ACS-VPC
- Add rule
 * inbounds rules (ssh, port 22, source - my Ip)
- add tag
 * name - name
 * value - ASC-bastion
 - create

 _for Nginx Servers: Access to Nginx should only be allowed from a Application Load balancer (ALB). At this point, we have not created a load balancer, therefore we will update the rules later. For now, just create it and put some dummy records as a place holder._

- security group name- ACS-nginx-reverse-proxy
- VPC - select vpc
- Add rule (http, https,ssh, port 80, 443, 22, source -  ASC-ext-ALB, ASC-ext-ALB, ASC-bastion respectivel)
 * inbounds rules 
 * http, 80, ASC-ext-ALB
 * https, 443, ASC-ext-ALB
 * ssh, 22, ASC-bastion
- add tag
 * name - name
 * value - ACS-nginx-reverse-proxy
 - create

 _For internal load balancer_


- security group name- ACS-int-alb
- VPC - select vpc
- Add rule (http, https, port 80, 443, source -  ACS-nginx-reverse-proxy, ACS-nginx-reverse-proxy, respectivel)
 * inbounds rules 
 * http, 80, ACS-nginx-reverse-proxy
 * https, 443, ACS-nginx-reverse-proxy
- add tag
 * name - name
 * value - ACS-int-alb
 - create

_for Webservers: Access to Webservers should only be allowed from the Nginx servers. Since we do not have the servers created yet, just put some dummy records as a place holder, we will update it later._

- security group name- ACS-webserver
- VPC - select vpc
- Add rule 
 * inbounds rules 
 * http, 80, ACS-int-alb
 * https, 443, ACS-int-alb
 * ssh, 22,  ASC-bastion
- add tag
 * name - name
 * value - ACS-webserver
 - create

_for Data Layer: Access to the Data layer, which is comprised of Amazon Relational Database Service (RDS) and Amazon Elastic File System (EFS) must be carefully desinged – only webservers should be able to connect to RDS, while Nginx and Webservers will have access to EFS Mountpoint._

- security group name- ACS-datalayer
- VPC - select vpc
- Add rule 
 * inbounds rules 
 * mysql/Aurora, 3306, ACS-webserver
 * nfs, 2049, ACS-webserver
 * mysql, 3306,  ASC-bastion
- add tag
 * name - name
 * value - ACS-datalayer
 - create

> TLS Certificates From [Amazon Certificate Manager (ACM)](https://aws.amazon.com/certificate-manager/)
- Confirm you already have domain and the DNS records are properly set
- Go to AWS certificate manager (ACM)
- Request for a public cetificate
- On the domain name, use wildcard- _*.domain.com_ where domain name is your domain name
- Next
- On theselect validation method, choose "DNS validation"
- Next
- On tag - name - name, value - ACS-cert
- review
- conform and request
- expand the validation
- click on create in Route 53

> [Amazon Elastic file system](https://us-east-1.console.aws.amazon.com/efs?region=us-east-1#/get-started)
- Create file system
- name - ACS-file-system
- VPC - Select your VPC
- select customize
- add tag
- tag key - name
- value - ACS-file-system
- next
- On the nextwor, select _private_subnet-1_, _private_subnet-2_
- Change the security group to datalayer _ACS-datalayer_

- On file system policy, choose default
- next
- review and create

> Access point
- Click on the file system created above
- select access points
- create access point

_for wordpress_
- name - worldpress
- Root directory path - /wordpress
- on POSIX user
* User ID - 0
* Group ID - 0
- On root directory creation permission
* Owner user ID - 0
* Owner group ID - 0
* POSIX permission for apply to the root directory path - 0755
- Add tag
* name - name
* value - wordpress-ap
- Create access point

_for tooling_
- name - tooling
- Root directory path - /tooling
- on POSIX user
* User ID - 0
* Group ID - 0
- On root directory creation permission
* Owner user ID - 0
* Owner group ID - 0
* POSIX permission for apply to the root directory path - 0755
- Add tag
* name - name
* value - tooling-ap
- Create access point

> [Amazon RDS](https://aws.amazon.com/rds/?trk=c0fcea17-fb6a-4c27-ad98-192318a276ff&sc_channel=ps&sc_campaign=acquisition&sc_medium=ACQ-P|PS-GO|Brand|Desktop|SU|Database|Solution|US|EN|Text&s_kwcid=AL!4422!3!548665196298!e!!g!!amazon%20relational%20db&ef_id=EAIaIQobChMIybH9rPD59wIVoG5vBB2OpAKCEAAYASABEgIRZPD_BwE:G:s&s_kwcid=AL!4422!3!548665196298!e!!g!!amazon%20relational%20db)

