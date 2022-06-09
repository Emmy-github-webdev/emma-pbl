#### What is Docker Conatiner?
A Docker conatiner is a loosely isolated environment runing within a host machine's kernel that allows us to run application specific code.

#### What is a Kernel? 

The kernel is the software at the core of an operating system, with complete control.

#### Relationship between Kernel and Docker

Docker runs on top of original machine's kernel  - making it the host machine.

#### Docker Engine 
- Docker engine consists of server proces to run docker features. It includes Docker server, an API, and command line interface.  Docker engine is the underline machine where docker is installed

- The server is also called the Docker daemon. **Daemon**- runs at the background processes on an operating system.

#### Why are containers useful?
- Portability to multiple OS environment
- Less time setting up, more time coding
- Development, CI, development environments.

#### Different between containers and VMs

- Containers include the application and all its dependencies. However, they share the OS kernel with other containers, running as isolated processes in user space on the host operating system. 
- Container is light weight and uses less disk space
- Container boot up faster
- Container has less isolation to run sharing between containers like kernel
- Virtual machines include the application, the required libraries or binaries, and a full guest operating system. Full virtualization requires more resources than containerization.
- each container runs inside of a special virtual machine per container.
- VMs use high disk space
- VMs takes time to boot up
- VM has complete isolation with each other and do not depends on one another to share resources

**Dockerhub** – is a public Docker registry

#### Docker Image

Docker image define the container code, libraries, environment variables, configuration files, and more.

#### Different between Image and Container

Image (Docker image) is a package, template or plan. While containers are running instances of images that are isolated with their own environment, network.

Docker image containers can run natively on Linux and Windows, however, Windows image can run only on Windows hosts and Linux image can run on Linux host and Windows hosts( using Hyper-V Linux VM

#### Docker Containers and Images

##### Docker Containers

Create an interactive terminal container with a name, an image, and a default command:

- Usage: docker create -it --name=<name> <image> <command>

<br>

Example: docker create -it --name=foo ubuntu bash

<br>

- List all running containers:

docker container ls

<br>

(list all containers, running or not): docker container ls -a

- Start a docker container:

Usage: docker start <container name or id>

<br>

Example: docker start foo

- Attach to a docker container:

Usage: docker attach <container name or id>

<br>

Example: docker attach foo

- Remove a container:

Usage: docker rm <container name or id>

<br>

Example: docker rm foo

- Force remove: docker rm foo -f

- Run a new container:

- Usage: docker run <image> <command>

Example with options: docker run --name=bar -it ubuntu bash

- Remove all containers:

docker container ls -aq | xargs docker container rm

- Docker Images

* Remove all images:

docker image ls -aq | xargs docker rmi -f

- Search for a docker image:

Usage: docker search <image>

<br>

Example: docker search ubuntu
