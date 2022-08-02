# Containers on AWS

**Docker:** is a software development platform to deploy apps.

#### Amazon ECs (Elastic Container Service) 
It is a highly scalable, fast, container management service that makes it easy to run, stop, and manage Docker constainers on a cluster of Amazon EC2 instances.

- **EC2 Launch Type:** You must provision and manage the infrastructure (EC2 instances). You run your containerized applications on a cluster of Amazon EC2 instances that you manage.
- **Fargate Launch Type:** is a technology that you can use with Amazon ECS to run conatiners without having to manage servers or cluster of Amazon EC2 instances. It is serverless.

### ECS Cluster Hands on
1. Launch AWS Management console
2. Search for ECS
3. Click on get started
4. Click on create cluster
5. Add the ECS name
6. Under infrastructure, select the launch type of your choice
7. create cluster

### Creating ECS Service - Hands on
1. Create task definition (To be run behind the in a service behind the loadbalancer)
 - On the ECS console, serach for task definitions
2. Create two security goup for the ECS task defination and ECS
3. Create ECS service and connect it to loadbalancer

### Amazon ECS - Auto Scaling
![](images/tutorials/ecs-auto-scaling.png)
![](images/tutorials/ecs-ec2-scaling.png)

### Amazon ECR
ECR is Elastic Container Registry. It store and manage Docker images on AWS.
![](images/tutorials/ecr.png)

### EKS
![](images/tutorials/eks.png)