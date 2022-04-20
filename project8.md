## PROJECT 8: Load Balancer Solution With Apache

[Resources](https://us02web.zoom.us/rec/share/_KBN1L8p-SxLasFT2CzL27d1AFQoZYYpN6lQLYGS3mlaVpaYoFQd2G3rD_AGHlfT.VjvwLtotuMIRVNQ_)
[Load Balancing](https://www.nginx.com/resources/glossary/load-balancing/)
[Layer 4 Load balancing](https://www.nginx.com/resources/glossary/layer-4-load-balancing/)
[Layer 7 Load Balancing](https://www.nginx.com/resources/glossary/layer-7-load-balancing/)

- In this project we will enhance our Tooling Website solution by adding a Load Balancer to disctribute traffic between Web Servers and allow users to access our website using a single URL.

-  A Load Balancer (LB) distributes clients’ requests among underlying Web Servers and makes sure that the load is distributed in an optimal way.

![](images/project7/arch.png)

> Task
_Deploy and configure an Apache Load Balancer for Tooling Website solution on a separate Ubuntu EC2 intance. Make sure that users can be served by Web servers through the Load Balancer._

> Prerequisites
- Make sure that you have following servers installed and configured within:

    * Two RHEL8 Web Servers
    * One MySQL DB Server (based on Ubuntu 20.04)
    * One RHEL8 NFS server

> CONFIGURE APACHE AS A LOAD BALANCER