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