# [Kubernetes or K8s](https://kubernetes.io/)

Kubernetes also known as K8s is an open-source system for automating deployment, scaling, and management of containerized application.

#### Container overview

Containers are isolated environment with their separate networking, processor, services mount.

#### Different between containers and VMs

	• Containers include the application and all its dependencies. However, they share the OS kernel with other containers, running as isolated processes in user space on the host operating system. 
	• Container is light weight and uses less disk space
	• Container boot up faster
	• Container has less isolation to run sharing between containers like kernel

	• Virtual machines include the application, the required libraries or binaries, and a full guest operating system. Full virtualization requires more resources than containerization.
	• each container runs inside of a special virtual machine per container.
	• VMs use high disk space
	• VMs takes time to boot up
	• VM has complete isolation with each other and do not depends on one another to share resources

#### Different between Image and Container

Image (Docker image) is a package, template or plan. While containers are running instances of images that are isolated with their own environment, network.

<br>

Docker image containers can run natively on Linux and Windows, however, Windows image can run only on Windows hosts and Linux image can run on Linux host and Windows hosts( using Hyper-V Linux VM

#### [container orchestration](https://www.redhat.com/en/topics/containers/what-is-container-orchestration)

Container orchestration automates the deployment, management, scaling, and networking of containers.

#### [Orchestration Technologies]

Orchestration technologies includes
1. Docker Swarm
2. Kubernetes
3. MESOS

#### Kubernetes architecture

1. **Node** is a machine in which kuberneteis installed. It is a worker machine.

2. **Cluster** is a set of nodes grouped together. It helps to solve the issue of when a node goes down.

3. **Master** is also a worker (node) with kubernete installed and configured as master. It watches over the other nodes in the cluster and provides orchestration to cluster node.

4. **[Components](https://kubernetes.io/docs/concepts/overview/components/** are services installed when kubernete is installed on a device. The services includes **API Server**, **Scheduler**, **Container runtime**, **bucket**, **Controller**, **etcd**

<br>

#### Master VS Worker Nodes

In kubernete, we have two types of servers: _Master_ and a _worker nodes_.

- **Master** consists of **Api server**, **etcd**, **controller**, **scheduler**

- **Worker Nodes** consists of **container runtime**, **kubelet**

5. **Kubectl** is a command line tool used to run commands against Kubernetes clusters.  It is used to deploy and manage applications on kubernetes cluster
- _kubectl run hello-minikube_ is used to deploy application on the cluster. In this case, the application name is **hello-minikube**
- _kubectl cluster-info_ is used to get information about the cluster
- _kubectl get nodes_ is used to list all nodes in the cluster




