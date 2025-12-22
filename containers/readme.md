# Docker
https://docs.docker.com/get-started/docker-concepts/building-images/understanding-image-layers/

Docker is an open platform for developing, shipping and running applications.

## Containers
Containers are isolated processes for each of the app's components. Each component - the frontend React app, the Python API engine, and the database - runs in its own isolated environment, completely isolated from everything else on your machine.

## Containers VS Virtual Machines.
VMs is an operating system with it's own kernel, hardware devices, applications, and programs.
Container is isolated process with all files it needs to run. 

## Image
A container image is a standardized package that includes all of the files, binaries, libraries, and configurations to run a container. Container images are composed of layers. Each layer represents a set of file system changes that add, remove, or modify files.

## Registry
An image registry is a centralized location for storing and sharing your container images. It can be either public (Docker hub) or private (Amazon Elastic container registry - ECR, Azure container registry - ACR, Google container registry - GCR).

## Registry vs. repository
A _registry_ is a centralized location that stores and manages container images, whereas a _repository_ is a collection of related container images within a registry. Think of it as a folder where you organize your images based on projects.

## Docker Compose 

Docker compose is a tool that lets you define and run multi-container applications using Docker, in a simple and repeatable way.

Instead of starting containers one by one with long docker run commands, you describe everything in a YAML file and start it with one command docker compose up.

## Dockerfile versus Compose file
A Dockerfile provides instructions to build a container image while a Compose file defines your running containers. Quite often, a Compose file references a Dockerfile to build an image to use for a particular service.

Different waye

```
version: "3"
services:
  web:
    image: "nginx:latest"
    ports:
      - "8080:80"
    restart: always
  web2:
    image: "nginx:latest"
    ports:
      - "8082:80"
    restart: always
networks:
  coffee:
    ipam:
      driver: default
      config:
        - subnet: "192.168.92.0/24"
```
 ```
version: "3.8"
services:
  wordpress:
    image: wordpress
    ports:
      - "8089:80"
    depends_on:
      - mysql
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: "coffee"
      WORDPRESS_DB_NAME: wordpress
  mysql:
      image: mysql:5.7
      environment:
        MYSQL_ROOT_PASSWORD: "coffee"
        MYSQL_DATABASE: wordpress
      volumes:
        - db_data:/var/lib/mysql
networks:
  wnet:
    ipam:
      driver: default
      config:
        - subnet: "192.268.100.1/24"
```
etc

## Image Layers
Each layer in an image contains a set of filesystem changes - additions, deletions, or modifications.

| No | Layer | Description |
|----|-------|-------------|
| 1  | App Source | 1st layer adds basic commands and package manager |
| 2  | App dependencies | 2nd layer installs dependencies for management |
| 3  | App requirements  | 3rd layer copies in an application's specificrequirements |
| 4 | Python and pip | 4th layer installs the application specific dependencies |
| 5 | Debian base | 5th layer copies in the actual source code of the application.

