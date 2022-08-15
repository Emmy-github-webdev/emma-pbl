[Kubernetes](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)

Kubernetes also known as K8s is an open-source system for automating deployment, scaling, and management of containerized application.
### How does Amazon EKS work?
![](images/how-kube-work.png)

### [Installing or Updating Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

Kubectl is a command line tool that you can use to communicate with kubernetes API server.

Determine whether you already have **kubectl** installed on your device.
```
kubectl version | grep Client | cut -d : -f 5
```
### [Installing or updating eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

eksctl is a command line tool use for creating and managing Kubernetes clusters in AWS Eks.

### [Create Cluster using eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
Node types includes
1. **Fargate-Linux-** Select this type of node if you want to run Linux applications on AWS Fargate. Fargate is a serverless compute engine that allow you deploy kubernetes pod without managing the EC2 instances.
2. **managed nodes**
3. **Windows self managed**
4. **Bottlerocket nodes**

### [Amazon EKS Clusters](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)

1. If you already have a cluster IAM role, or you're going to create your cluster with eksctl, then you can skip this step. By default, eksctl creates a role for you.
  - To create an Amazon EKS cluster IAM role, run the following command to create an IAM trust policy JSON file.
  ```
        cat >eks-cluster-role-trust-policy.json <<EOF
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
          }
        ]
      }
      EOF
  ```
  - Create the Amazon EKS cluster IAM role. If necessary, preface **eks-cluster-role-trust-policy.json** with the path on your computer that you wrote the file to in the previous step. The command associates the trust policy that you created in the previous step to the role. To create an IAM role, the IAM entity (user or role) that is creating the role must be assigned the following IAM action (permission): **iam:CreateRole**.
  ```
  aws iam create-role --role-name myAmazonEKSClusterRole --assume-role-policy-document file://"eks-cluster-role-trust-policy.json"
  ```
  - Attach the Amazon EKS managed policy named **AmazonEKSClusterPolicy** to the role. To attach an IAM policy to an IAM entity (user or role), the IAM entity that is attaching the policy must be assigned one of the following IAM actions (permissions): iam:AttachUserPolicy or iam:AttachRolePolicy.
  ```
  aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy --role-name myAmazonEKSClusterRole
  ```

2. Create an Amazon EKS cluster using AWS CLI

- Replace **region-code** with the AWS Region that you want to create your cluster in.

- Replace **my-cluster** with a name for your cluster.

- Replace **1.23** with any Amazon EKS supported version.

- Replace **111122223333** with your account ID and **myAmazonEKSClusterRole** with the name of your cluster IAM role.

Replace the values for subnetIds with your own. You can also add additional IDs.
```
  aws eks create-cluster --region region-code --name my-cluster --kubernetes-version 1.23 \
    --role-arn arn:aws:iam::111122223333:role/myAmazonEKSClusterRole \
    --resources-vpc-config subnetIds=subnet-ExampleID1,subnet-ExampleID2,securityGroupIds=sg-ExampleID1
```
>  Optional settings - The following are optional settings that, if required, must be added to the previous command.

- If you want to specify which IPv4 Classless Inter-domain Routing (CIDR) block Kubernetes assigns service IP addresses from, you must specify it by adding the **--kubernetes-network-config serviceIpv4Cidr=CIDR block**
- If you're creating a cluster of version 1.21 or later and want the cluster to assign IPv6 addresses to pods and services instead of IPv4 addresses, add **--kubernetes-network-config ipFamily=ipv6**

- It takes several minutes to provision the cluster. You can query the status of your cluster with the following command.
```
aws eks describe-cluster \
    --region region-code \
    --name my-cluster \
    --query "cluster.status"
```
3. If you created your cluster using eksctl, then you can skip this step. This is because eksctl already completed this step for you. Enable kubectl to communicate with your cluster by adding a new context to the [kubectl config file](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html). The example output is as follows.
```
Added new context arn:aws:eks:region-code:111122223333:cluster/my-cluster to /home/username/.kube/config
```
4. Confirm communication with your cluster by running the following command.
```
kubectl get svc
```

### Updating Kubernetes version

1. Compare the Kubernetes version of your cluster control plane to the Kubernetes version of your nodes.

- Get the Kubernetes version of your cluster control plane with the **kubectl version --short** command.
```
kubectl version --short
```
- Get the Kubernetes version of your nodes with the kubectl get nodes command. This command returns all self-managed and managed Amazon EC2 and Fargate nodes. Each Fargate pod is listed as its own node.
```
kubectl get nodes
```
2. By default, the pod security policy admission controller is enabled on Amazon EKS clusters. Before updating your cluster, ensure that the proper pod security policies are in place. This is to avoid potential security issues. You can check for the default policy with the **kubectl get psp eks.privileged** command.
```
kubectl get psp eks.privileged
```
If you receive the following error, see default pod security policy before proceeding.
```
Error from server (NotFound): podsecuritypolicies.extensions "eks.privileged" not found
```
3. Updating Kubernetes version using AWS CLI
 - Update your Amazon EKS cluster with the following AWS CLI command. Replace the example values with your own.
```
aws eks update-cluster-version \
 --region region-code \
 --name my-cluster \
 --kubernetes-version 1.23
```
- Monitor the status of your cluster update with the following command. Use the cluster name and update ID that the previous command returned. When a Successful status is displayed, the update is complete. The update takes several minutes to complete.
```
aws eks describe-update \
  --region region-code \
  --name my-cluster \
  --update-id b5f0ba18-9a87-4450-b5a0-825e6e84496f
```
4. After your cluster update is complete, update your nodes to the same Kubernetes minor version as your updated cluster.

### To delete an Amazon EKS cluster with the AWS CLI
1. List all services running in your cluster.
```
kubectl get svc --all-namespaces
```
2. Delete any services that have an associated EXTERNAL-IP value. These services are fronted by an Elastic Load Balancing load balancer, and you must delete them in Kubernetes to allow the load balancer and associated resources to be properly released.
```
kubectl delete svc service-name
```
3. Delete all node groups and Fargate profiles.
- List the node groups in your cluster with the following command.
```
aws eks list-nodegroups --cluster-name my-cluster
```
- Delete each node group with the following command. Delete all node groups in the cluster.
```
aws eks delete-nodegroup --nodegroup-name my-nodegroup --cluster-name my-cluster
```
- List the Fargate profiles in your cluster with the following command.
```
aws eks list-fargate-profiles --cluster-name my-cluster
```
- Delete each Fargate profile with the following command. Delete all Fargate profiles in the cluster.
```
aws eks delete-fargate-profile --fargate-profile-name my-fargate-profile --cluster-name my-cluster
```

4. Delete all self-managed node AWS CloudFormation stacks.
- List your available AWS CloudFormation stacks with the following command. Find the node template name in the resulting output.
```
aws cloudformation list-stacks --query "StackSummaries[].StackName"
```
- Delete each node stack with the following command, replacing node-stack with your node stack name. Delete all self-managed node stacks in the cluster.
```
aws cloudformation delete-stack --stack-name node-stack
```
5. Delete the cluster with the following command, replacing my-cluster with your cluster name.
```
aws eks delete-cluster --name my-cluster
```
6. Optional - Delete the VPC AWS CloudFormation stack.
- List your available AWS CloudFormation stacks with the following command. Find the VPC template name in the resulting output.
```
aws cloudformation list-stacks --query "StackSummaries[].StackName"
```
- Delete the VPC stack with the following command, replacing my-vpc-stack with your VPC stack name.
```
aws cloudformation delete-stack --stack-name my-vpc-stack
```
### Amazon EKS cluster endpoint access control
This will helps you to enable private access for your Amazon EKS cluster's Kubernetes API server endpoint and limit, or completely disable, public access from the internet.

<br>

When you create a new cluster, Amazon EKS creates an endpoint for the managed Kubernetes API server that you use to communicate with your cluster (using Kubernetes management tools such as kubectl). By default, this API server endpoint is public to the internet, and access to the API server is secured using a combination of AWS Identity and Access Management (IAM) and native Kubernetes [Role Based Access Control](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) (RBAC).

<br>

You can enable private access to the Kubernetes API server so that all communication between your nodes and the API server stays within your VPC. You can limit the IP addresses that can access your API server from the internet, or completely disable internet access to the API server.

<br>

When you enable endpoint private access for your cluster, Amazon EKS creates a Route 53 private hosted zone on your behalf and associates it with your cluster's VPC. This private hosted zone is managed by Amazon EKS, and it doesn't appear in your account's Route 53 resources. In order for the private hosted zone to properly route traffic to your API server, your VPC must have enableDnsHostnames and enableDnsSupport set to true, and the DHCP options set for your VPC must include AmazonProvidedDNS in its domain name servers list. For more information, see Updating DNS support for your VPC in the Amazon VPC User Guide

<br>

You can define your API server endpoint access requirements when you create a new cluster, and you can update the API server endpoint access for a cluster at any time.

### Modifying cluster endpoint access 
| API server endpoint access options |
-
| Endpoint public access|Endpoint private access|Behavior|
-                        -                        -
| Enabled | Disable |This is the default behavior for new Amazon EKS clusters. Kubernetes API requests that originate from within your cluster's VPC (such as node to control plane communication) leave the VPC but not Amazon's network. Your cluster API server is accessible from the internet. You can, optionally, limit the CIDR blocks that can access the public endpoint. If you limit access to specific CIDR blocks, then it is recommended that you also enable the private endpoint, or ensure that the CIDR blocks that you specify include the addresses that nodes and Fargate pods (if you use them) access the public endpoint from.|
|Enabled | Enabled| Kubernetes API requests within your cluster's VPC (such as node to control plane communication) use the private VPC endpoint. Your cluster API server is accessible from the internet. You can, optionally, limit the CIDR blocks that can access the public endpoint.|
|Disabled|Enabled| All traffic to your cluster API server must come from within your cluster's VPC or a connected network. There is no public access to your API server from the internet. Any kubectl commands must come from within the VPC or a connected network. For connectivity options, see Accessing a private only API server. The cluster's API server endpoint is resolved by public DNS servers to a private IP address from the VPC. In the past, the endpoint could only be resolved from within the VPC. If your endpoint does not resolve to a private IP address within the VPC for an existing cluster, you can: Enable public access and then disable it again. You only need to do so once for a cluster and the endpoint will resolve to a private IP address from that point forward. Update your cluster.|

You can modify your cluster API server endpoint access using the AWS Management Console or AWS CLI. Select the tab with the name of the tool that you'd like to use to modify your endpoint access with.

### To modify your cluster API server endpoint access using the AWS CLI
1. Update your cluster API server endpoint access with the following AWS CLI command. Substitute your cluster name and desired endpoint access values. If you set endpointPublicAccess=true, then you can (optionally) enter single CIDR block, or a comma-separated list of CIDR blocks for publicAccessCidrs. 
```
aws eks update-cluster-config \
    --region region-code \
    --name my-cluster \
    --resources-vpc-config endpointPublicAccess=true,publicAccessCidrs="203.0.113.5/32",endpointPrivateAccess=true
```
_Sample output_
```
{
    "update": {
        "id": "e6f0905f-a5d4-4a2a-8c49-EXAMPLE00000",
        "status": "InProgress",
        "type": "EndpointAccessUpdate",
        "params": [
            {
                "type": "EndpointPublicAccess",
                "value": "true"
            },
            {
                "type": "EndpointPrivateAccess",
                "value": "true"
            },
            {
                "type": "publicAccessCidrs",
                "value": "[\203.0.113.5/32\"]"
            }
        ],
        "createdAt": 1576874258.137,
        "errors": []
    }
}
```
2. Monitor the status of your endpoint access update with the following command, using the cluster name and update ID that was returned by the previous command.
```
aws eks describe-update \
    --region region-code \
    --name my-cluster \
    --update-id e6f0905f-a5d4-4a2a-8c49-EXAMPLE00000
```

_Sample Output_
```
{
    "update": {
        "id": "e6f0905f-a5d4-4a2a-8c49-EXAMPLE00000",
        "status": "Successful",
        "type": "EndpointAccessUpdate",
        "params": [
            {
                "type": "EndpointPublicAccess",
                "value": "true"
            },
            {
                "type": "EndpointPrivateAccess",
                "value": "true"
            },
            {
                "type": "publicAccessCidrs",
                "value": "[\203.0.113.5/32\"]"
            }
        ],
        "createdAt": 1576874258.137,
        "errors": []
    }
}
```
### Accessing a private only API server
Connected network, Amazon EC2 bastion host, or AWS Cloud9 IDE.
