# Introduction

#### What is Docker Conatiner?
A Docker conatiner is a loosely isolated environment runing within a host machine's kernel that allows us to run application specific code.

#### What is a Kernel? 

The kernel is the software at the core of an operating system, with complete control.

#### Relationship between Kernel and Docker

Docker runs on top of original machine's kernel  - making it the host machine.

#### Docker Engine 
- Docker engine consists of server proces to run docker features. It includes Docker server, an API, and command line interface.  Docker engine is the underline machine where docker is installed

- The server is also called the Docker daemon. **Daemon**- runs at the background processes on an operating system.

* [Docker for Mac](https://docs.docker.com/desktop/mac/install/)
* [Docker for Linux](https://docs.docker.com/desktop/linux/)
```
# Install docker on RedHat
sudo yum install -y docker

# Start Docker
sudo service docker start

# Display usage of Docker
docker

# Check user permission
docker ps

# Grant current user permission, and reconnect to enable the permission
sudo usermod -G docker ec2-user

# After reconnect
docker ps

```

_On Ubuntu_

```
wget -qO- https://get.docker.com/ | sh

# Check user permission
docker ps

# Grant current user permission, and reconnect to enable the permission
sudo usermod -G docker ${whoami}
```

* [Docker for Windows](https://docs.docker.com/desktop/windows/install/)