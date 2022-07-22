# Amazon VPC and Subnets
Amazon Virtual Private Cloud (VPC)enable you to connect your on-premises resources to AWS Infrastructure through a virtual private network.

### VPC Peering 
A peering connection can be made between your own VPCs or with a VPC in another AWS account, as long as it is in the same region. If you have instances in VPC A, they wouldn't be able to communicate with instances in VPC B or C unless you set up a peering connection. Peering is a one-to-one relationship; a VPC can have multiple peering connections to other VPCs

### Private, Public, and Elastic IP Addresses
- **Private IP addresses**: IP addresses not reachable over the internet are defined as private. Private IPs enable communication between instances in the same network.
- **Public IP addresses**: Public IP addresses are used for communication between other instances on the internet and yours. Each instance with a public IP address is assigned an external DNS hostname too. Public IP addresses linked to your instances are from Amazon's list of public IPs. On stopping or terminating your instance, the public IP address gets released, and a new one is linked to the instance when it restarts. For retention of this public IP address even after stoppage or termination, an elastic IP address needs to be used.
- **Elastic IP Addresses**: Elastic IP addresses are static or persistent public IPs that come with your account. If any of your software or instances fail, they can be remapped to another instance quickly with the elastic IP address. An elastic IP address remains in your account until you choose to release it. A charge is associated with an Elastic IP address if it is in your account, but not allocated to an instance.

### Subnet
AWS defines a subnet as a range of IP addresses in your VPC. You can launch AWS resources into a selected subnet. 
### Public and Private Subnets

A public subnet is used for resources that must be connected to the internet; web servers are an example. Private subnets are for resources that don't need an internet connection, or that you want to protect from the internet; database instances are an example.

### Networking
- **Internet Gateway**: It enables communication between instances in your VPC and the internet.

### It enables communication between instances in your VPC and the internet.

Amazon defines a route table as a set of rules, called routes, which are used to determine where network traffic is directed.