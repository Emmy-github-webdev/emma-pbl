# Setup Kubernetes

There are different ways to setup kubernete:
1. It can be installed on a local machine
2. On VM using either **minikube**, **microk8s**, or **kubeadm**

<br>

1. [Install kunectl](https://kubernetes.io/docs/tasks/tools/)

2. Enable **virtualization**
* for Windows, Control panel -> Turn feature on and off
* for Linus  _sudo grep -E --color 'vmx|svm' /proc/cpuinfo_

3. [Install minikube](https://minikube.sigs.k8s.io/docs/start/)

4. Run **minikube start** command to start the minikube
5. Run **minikube status** to view the status of the minikube
6. Run **kubectl get nodes** to confirm the command is working
7. Create a sample deployment and expose it on port 8080:

```
kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
# check how long the hello-minikube has been running
kubectl get deployments
# To access the hello-minikube Deployment, expose it as a service
kubectl expose deployment hello-minikube --type=NodePort --port=8080
# Get the hello-minikube URL
kubectl get services hello-minikube
# Run
kubectl get services hello-minikube

# Alternatively, use kubectl to forward the port:
kubectl port-forward service/hello-minikube 7080:8080

```
8. Your application is now available at **http://localhost:7080/**
9. Delete minikube cluster

```
# Delete only hello-minikube service
minikube delete services hello-minikube
# Delete all minkube services
minikube delete --all
# Delete hello-minikube deployment
kubectl delete deployment hello-minikube
# The deployment should show terminating stage
kubectl get pods
# After a while, the deployment should disapear
kubectl get pods
```

#### K8s installation options

To successfully implement "K8s From-Ground-Up", the following and even more will be done by you as a K8s administrator:

<br>

- Install and configure master (also known as control plane) components and worker nodes (or just nodes).
- Apply security settings across the entire cluster (i.e., encrypting the data 
  * in transit, and at rest)
In transit encryption means encrypting communications over the network using HTTPS
  * At rest encryption means encrypting the data stored on a disk
- Plan the capacity for the backend data store etcd
Configure network plugins for the containers to communicate
- Manage periodical upgrade of the cluster
- Configure observability and auditing

#### STEP 0-INSTALL CLIENT TOOLS BEFORE BOOTSTRAPPING THE CLUSTER.
