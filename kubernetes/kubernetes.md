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

