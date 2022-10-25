# Introduction

[Docker guides](https://github.com/15Dkatz/docker-guides)

#### What is Docker Conatiner?
- Docker is a platform that let you package, develop, and run applications in containers.
- A Docker conatiner is a loosely isolated environment runing within a host machine's kernel that allows us to run application specific code.

- Container is a virtual environment on top of the OS kernel to capture all its software - libraries, dependencies etc.

#### What is a Kernel? 

The kernel is the core software running on a computer that handles a very low level functionality like allocating memory.

#### Why Docker
Docker is portable to the major architectures and operating system. Docker image created on Mac can run on Windows or Linux.

#### Docker Main Features
- Create containers and images
- Docker-compose for multicontainer application
- Docker-swarm to utilize multiple machines running Docker.

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