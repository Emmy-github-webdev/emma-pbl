# ORCHESTRATING CONTAINERS ACROSS MULTIPLE VIRTUAL SERVERS WITH KUBERNETES. PART 1

##### Why migrate from Docker Compose to K8s

In the previous project you successfully deployed your Docker containers using Docker Compose, it is a great tool that helps avoiding execution of multiple CLI commands by preparing a declarative configuration file. It is handy when you deploy one or a few containers, but in most cases, it does not fit for production deployments.

<br>

Because of the many limitations that Docker Compose has, it is very important for us to consider migrating our solution to more an advanced technology. The most common alternatives to Compose, amongst a few others, are **Docker Swarm** and **Kubernetes**.

##### What is wrong with Docker Compose?

It is important to understand that, DevOps is about "Culture" and NOT "Tools" Therefore, it is not correct to say that one tool is better than another; different organizations have different needs and a good tool for one team may be bad for another just because their needs are not the same. In some teams, Docker Compose fit their needs perfectly, despite the perceived limitations. The major limitation of Docker Compose is that it can only be used to run workloads on a single computer host. Now, that is an obvious limitation because if our **Tooling Application** and its **MySQL Database** are all running on a single VM, like we did in Project 20, then this host is considered as a SPOF (i.e. – Single Point Of Failure).

<br>

So, could we say there is something wrong with Docker Compose? Not exactly, as a matter of fact, it is being used a lot in the industry. It fits well into some use cases that require speedy development and Proof of Concepts. As you will soon see, Kubernetes is a lot more complex technology, and it may be an overkill for some use cases.

##### Container Orchestration with Kubernetes

_What is Container Orchestration?_

_Two important things to remember about Docker containers are:_

- Unlike virtual machines, they are not designed to run for a very long time. By design, Docker containers are ephemeral. By “ephemeral” it means that a container can be stopped and destroyed, and a new one can be built from the same Docker image and put in place with an absolute minimum set-up and configuration requirement.

- To ensure that container workloads are highly scalable, they must be configured to run across multiple compute nodes. A compute node can be a physical server or a virtual machine with Docker engine installed to run your containers.

<br>

_If we had two compute nodes to run our containers, let us consider a following scenarios:_

- Given the two points mentioned above, if containers are configured to run across 2 computer nodes, and a particular container, running on Node 1 dies, how will it know that it can spin up again on Node 2?
- Let us imagine that Tooling website container is running on Node 1, and MySQL container is running on Node 2, how will both containers be able to communicate with each other? Remember in Project 20, we had to create a custom network on the same host and ensure that they can communicate through that network. But in the case of 2 separate hosts, this is natively not possible.

<br>

**Container orchestration** is a concept that allows to address these two scenarios, it provides automation of all the aspects of coordinating and managing containers. Container orchestration is focused on managing life cycle of containers and their dynamic environments.

<br>

It is about automating the entire lifecycle of containers running across multiple nodes:

<br>

- Configuring and scheduling of containers on nodes
- Ensuring the availability of containers, even when they die
- Scaling of containers to equally balance application workloads across infrastructure
- Allocation of resources between containers
- Load balancing, traffic routing and service discovery of containers
- Health monitoring of containers
- Securing the interactions between containers.

<br>

Kubernetes is a tool designed to do Container Orchestration and it does its job very well when correctly configured.

<br>

As mentioned earlier, there are other alternatives to Docker Compose. But, throughout the entire PBL program, we will not focus on **Docker Swarm**. We will rather spend more time with Kubernetes. Part of the reason for this is because Kubernetes has more functionalities and is widely in use in the industry.

<br>

To know when to choose between Docker Swarm and Kubernetes, [Here is an interesting article to read](https://dzone.com/articles/quotdocker-swarm-or-kubernetesquot-is-it-the-right) with some very enlightening stats.

#### [KUBERNETES ARCHITECTURE](https://kubernetes.io/docs/concepts/overview/components/)

Kubernetes is a not a single package application that you can install with one command, it is comprised of several components, some of them can be deployed as services, some can be also deployed as separate containers

<br>

First, you will need some client tools installed and configurations made on your client workstation:

- [awscli](https://aws.amazon.com/cli/) – is a unified tool to manage your AWS services

- [kubectl](https://kubernetes.io/docs/reference/kubectl/) – this command line utility will be your main control tool to manage your K8s cluster. You will use this tool so many times, so you will be able to type ‘kubetcl’ on your keyboard with a speed of light. You can always make a shortcut (alias) to just one character ‘k’. Also, add this extremely useful official kubectl Cheat Sheet to your bookmarks, it has examples of the most used **‘kubectl’** commands.

- [cfssl](https://blog.cloudflare.com/introducing-cfssl/) – an open source toolkit for everything TLS/SSL from [Cloudflare](https://www.cloudflare.com/)

- [cfssljson](https://github.com/cloudflare/cfssl) – a program, which takes the JSON output from the **cfssl** and writes certificates, keys, [CSRs](https://en.wikipedia.org/wiki/Certificate_signing_request), and bundles to disk.

_Install and configure AWS CLI_

<br>

- Configure AWS CLI to access all AWS services used, for this you need to have a user with programmatic access keys configured in AWS Identity and Access Management (IAM)

- Generate access keys and store them in a safe place.

- On your local workstation download and install [the latest version of AWS CLI](https://aws.amazon.com/cli/)

<br>

To [configure your AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) – run your shell (or cmd if using Windows) and run:

```
aws configure --profile %your_username%
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```

Test your AWS CLI by running:

```
aws ec2 describe-vpcs
```

and check if you can see VPC details.

_Install kubectl_

Kubernetes cluster has a Web API that can receive HTTP/HTTPS requests, but it is quite cumbersome to **curl** an API each and every time you need to send some command, so **kubectl** command tool was developed to ease a K8s administrator’s life.

<br>

With this tool you can easily interact with Kubernetes to deploy applications, inspect and manage cluster resources, view logs and perform many more administrative operations.

###### Linux

```
# Download the binary

wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl

# Make it executable

chmod +x kubectl

# Move to the Bin directory

sudo mv kubectl /usr/local/bin/

# Verify that kubectl version 1.21.0 or higher is installed:

kubectl version --client
```

_Output_

```
Client Version: version.Info{Major:"1", Minor:"20+", GitVersion:"v1.20.4-dirty", GitCommit:"e87da0bd6e03ec3fea7933c4b5263d151aafd07c", GitTreeState:"dirty", BuildDate:"2021-03-15T10:03:32Z", GoVersion:"go1.16.2", Compiler:"gc", Platform:"darwin/amd64"}
```

##### Install CFSSL and CFSSLJSON

_cfssl_ is an open source tool by **Cloudflare** used to setup a **Public Key Infrastructure** ([PKI Infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure)) for generating, signing and bundling TLS certificates. In previous projects you have experienced the use of **Letsencrypt** for the similar use case. Here, **cfssl** will be configured as a Certificate Authority which will issue the certificates required to spin up a Kubernetes cluster.

<br>

Download, install and verify successful installation of **cfssl** and **cfssljson**:

<br>

_ Install CFSSL and CFSSLJSON-linux_

```
wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson


  chmod +x cfssl cfssljson


  sudo mv cfssl cfssljson /usr/local/bin/
  ```
#### AWS CLOUD RESOURCES FOR KUBERNETES CLUSTER

 it is highly recommended to start out first with manual provisioning using **awscli** and have thorough knowledge about the whole setup. After that, you can destroy the entire project and start all over again using Terraform. 

 <br>

_Step 1 – Configure Network Infrastructure_

##### Virtual Private Cloud – VPC

1. Create a directory named **k8s-cluster-from-ground-up**
2. Create a VPC and store the ID as a variable:

```
VPC_ID=$(aws ec2 create-vpc \
--cidr-block 172.31.0.0/16 \
--output text --query 'Vpc.VpcId'
)
```

3. Tag the VPC so that it is named:

```
NAME=k8s-cluster-from-ground-up

aws ec2 create-tags \
  --resources ${VPC_ID} \
  --tags Key=Name,Value=${NAME}

 ```

##### Domain Name System – DNS
4. Enable DNS support for your VPC:

```
aws ec2 modify-vpc-attribute \
--vpc-id ${VPC_ID} \
--enable-dns-support '{"Value": true}'
```

5. Enable DNS support for hostnames:
```
aws ec2 modify-vpc-attribute \
--vpc-id ${VPC_ID} \
--enable-dns-hostnames '{"Value": true}'
```

##### AWS Region

6. Set the required region

```
AWS_REGION=eu-central-1
```

#### Dynamic Host Configuration Protocol – DHCP

7. Configure DHCP Options Set:

[Dynamic Host Configuration Protocol (DHCP)](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol) is a network management protocol used on Internet Protocol networks for automatically assigning IP addresses and other communication parameters to devices connected to the network using a client–server architecture.

<br>

**AWS** automatically creates and associates a DHCP option set for your Amazon VPC upon creation and sets two options: **domain-name-servers** (defaults to **AmazonProvidedDNS**) and domain-name (defaults to the domain name for your set region). **AmazonProvidedDNS** is an Amazon Domain Name System (DNS) server, and this option enables DNS for instances to communicate using DNS names.

<br>

By default EC2 instances have fully qualified names like **ip-172-50-197-106.eu-central-1.compute.internal**. But you can set your own configuration using an example below.

```
DHCP_OPTION_SET_ID=$(aws ec2 create-dhcp-options \
  --dhcp-configuration \
    "Key=domain-name,Values=$AWS_REGION.compute.internal" \
    "Key=domain-name-servers,Values=AmazonProvidedDNS" \
  --output text --query 'DhcpOptions.DhcpOptionsId')
```

8. Tag the DHCP Option set:

```
aws ec2 create-tags \
  --resources ${DHCP_OPTION_SET_ID} \
  --tags Key=Name,Value=${NAME}
  ```

9. Associate the DHCP Option set with the VPC: 

```
aws ec2 associate-dhcp-options \
  --dhcp-options-id ${DHCP_OPTION_SET_ID} \
  --vpc-id ${VPC_ID}
  ```

  #### Subnet

 10. Create the Subnet: 

 ```
 SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 172.31.0.0/24 \
  --output text --query 'Subnet.SubnetId')
aws ec2 create-tags \
  --resources ${SUBNET_ID} \
  --tags Key=Name,Value=${NAME}
 
  ```

#### Internet Gateway – IGW

11. Create the Internet Gateway and attach it to the VPC:

```

INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway \
--output text --query 'InternetGateway.InternetGatewayId')
aws ec2 create-tags \
--resources ${INTERNET_GATEWAY_ID} \
--tags Key=Name,Value=${NAME}

aws ec2 attach-internet-gateway \
--internet-gateway-id ${INTERNET_GATEWAY_ID} \
--vpc-id ${VPC_ID}
```

#### Route tables

12. Create route tables, associate the route table to subnet, and create a route to allow external traffic to the Internet through the Internet Gateway:

```
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id ${VPC_ID} \
  --output text --query 'RouteTable.RouteTableId')
aws ec2 create-tags \
  --resources ${ROUTE_TABLE_ID} \
  --tags Key=Name,Value=${NAME}
aws ec2 associate-route-table \
  --route-table-id ${ROUTE_TABLE_ID} \
  --subnet-id ${SUBNET_ID}
aws ec2 create-route \
  --route-table-id ${ROUTE_TABLE_ID} \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id ${INTERNET_GATEWAY_ID}
```

#### Output:

```
{
    "AssociationId": "rtbassoc-07a8877e92504def7",
    "AssociationState": {
        "State": "associated"
    }
}
{
    "Return": true
}
```

#### SECURITY GROUPS

13. Configure security groups

```
# Create the security group and store its ID in a variable
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --group-name ${NAME} \
  --description "Kubernetes cluster security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')

# Create the NAME tag for the security group
aws ec2 create-tags \
  --resources ${SECURITY_GROUP_ID} \
  --tags Key=Name,Value=${NAME}

# Create Inbound traffic for all communication within the subnet to connect on ports used by the master node(s)
aws ec2 authorize-security-group-ingress \
    --group-id ${SECURITY_GROUP_ID} \
    --ip-permissions IpProtocol=tcp,FromPort=2379,ToPort=2380,IpRanges='[{CidrIp=172.31.0.0/24}]'

# # Create Inbound traffic for all communication within the subnet to connect on ports used by the worker nodes
aws ec2 authorize-security-group-ingress \
    --group-id ${SECURITY_GROUP_ID} \
    --ip-permissions IpProtocol=tcp,FromPort=30000,ToPort=32767,IpRanges='[{CidrIp=172.31.0.0/24}]'

# Create inbound traffic to allow connections to the Kubernetes API Server listening on port 6443
aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol tcp \
  --port 6443 \
  --cidr 0.0.0.0/0

# Create Inbound traffic for SSH from anywhere (Do not do this in production. Limit access ONLY to IPs or CIDR that MUST connect)
aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0

# Create ICMP ingress for all types
aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol icmp \
  --port -1 \
  --cidr 0.0.0.0/0
```

#### Network Load Balancer

14. Create a network Load balancer,

```
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
--name ${NAME} \
--subnets ${SUBNET_ID} \
--scheme internet-facing \
--type network \
--output text --query 'LoadBalancers[].LoadBalancerArn')
```

#### Tagret Group

15. Create a target group: (For now it will be unhealthy because there are no real targets yet.)

```
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
  --name ${NAME} \
  --protocol TCP \
  --port 6443 \
  --vpc-id ${VPC_ID} \
  --target-type ip \
  --output text --query 'TargetGroups[].TargetGroupArn')
```

16. Register targets: (Just like above, no real targets. You will just put the IP addresses so that, when the nodes become available, they will be used as targets.)

```
aws elbv2 register-targets \
  --target-group-arn ${TARGET_GROUP_ARN} \
  --targets Id=172.31.0.1{0,1,2}
```

17. Create a listener to listen for requests and forward to the target nodes on TCP port **6443**

```
aws elbv2 create-listener \
--load-balancer-arn ${LOAD_BALANCER_ARN} \
--protocol TCP \
--port 6443 \
--default-actions Type=forward,TargetGroupArn=${TARGET_GROUP_ARN} \
--output text --query 'Listeners[].ListenerArn'
```

#### K8s Public Address

18. Get the Kubernetes Public address

```
KUBERNETES_PUBLIC_ADDRESS=$(aws elbv2 describe-load-balancers \
--load-balancer-arns ${LOAD_BALANCER_ARN} \
--output text --query 'LoadBalancers[].DNSName')
```

#### Step 2 – Create Compute Resources
_AMI_

1. Get an image to create EC2 instances:
```
IMAGE_ID=$(aws ec2 describe-images --owners 099720109477 \
  --filters \
  'Name=root-device-type,Values=ebs' \
  'Name=architecture,Values=x86_64' \
  'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*' \
  | jq -r '.Images|sort_by(.Name)[-1]|.ImageId')
```
_SSH key-pair_

2. Create SSH Key-Pair

```
mkdir -p ssh

aws ec2 create-key-pair \
  --key-name ${NAME} \
  --output text --query 'KeyMaterial' \
  > ssh/${NAME}.id_rsa
chmod 600 ssh/${NAME}.id_rsa
```

#### EC2 Instances for Controle Plane (Master Nodes)

3. Create 3 Master nodes: **Note** – Using _t2.micro_ instead of _t2.small_ as _t2.micro_ is covered by AWS free tier

```
for i in 0 1 2; do
  instance_id=$(aws ec2 run-instances \
    --associate-public-ip-address \
    --image-id ${IMAGE_ID} \
    --count 1 \
    --key-name ${NAME} \
    --security-group-ids ${SECURITY_GROUP_ID} \
    --instance-type t2.micro \
    --private-ip-address 172.31.0.1${i} \
    --user-data "name=master-${i}" \
    --subnet-id ${SUBNET_ID} \
    --output text --query 'Instances[].InstanceId')
  aws ec2 modify-instance-attribute \
    --instance-id ${instance_id} \
    --no-source-dest-check
  aws ec2 create-tags \
    --resources ${instance_id} \
    --tags "Key=Name,Value=${NAME}-master-${i}"
done
```

#### EC2 Instances for Worker Nodes

1. Create 3 worker nodes:

```
for i in 0 1 2; do
  instance_id=$(aws ec2 run-instances \
    --associate-public-ip-address \
    --image-id ${IMAGE_ID} \
    --count 1 \
    --key-name ${NAME} \
    --security-group-ids ${SECURITY_GROUP_ID} \
    --instance-type t2.micro \
    --private-ip-address 172.31.0.2${i} \
    --user-data "name=worker-${i}|pod-cidr=172.20.${i}.0/24" \
    --subnet-id ${SUBNET_ID} \
    --output text --query 'Instances[].InstanceId')
  aws ec2 modify-instance-attribute \
    --instance-id ${instance_id} \
    --no-source-dest-check
  aws ec2 create-tags \
    --resources ${instance_id} \
    --tags "Key=Name,Value=${NAME}-worker-${i}"
done
```

