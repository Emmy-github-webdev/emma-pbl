# [Kuberbnet Concept](https://kubernetes.io/docs/concepts/)

- **[POD](https://kubernetes.io/docs/concepts/workloads/pods/** is a single instance of an application. POD has one on one relationship with continer. To scale up is to add new POD, to scale down is to delete an existing POD.

#### Deploy PODs

```
# Deploy nginx image from docker hub
kubectl run nginx --image nginx
# Get list of PODS
kubectl get pods
```

#### Demo - Deploy PODs in a minikube cluster

```
# deploy nginx image from Docker Hub
kubectl run nginx --image=nginx
# Check status of the POD
kubectl get pods
# for more details about the pod
kubectl describe pod nginx
# For additonal information
kubectl get pods -o wide
```

