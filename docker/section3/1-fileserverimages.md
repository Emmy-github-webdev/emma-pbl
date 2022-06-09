#### Build a file server image
1. _Create project directory and docker image_
- Create a folder **docker**
- Change directory to **docker** folder
```
mkdir docker
cd docker
```
- Create folder for this folder server image **serve**
- Change directory to **serve** folder
- Create a **display** folder 
```
docker > mkdir serve
cd serve
docker/serve > mkdir display
```
- Write to the display some text
```
docker/serve $ cat > display/foo.txt
Foo

ctrl + d

cat display/foo.txt
```

- Create index file that will be view on browser

```
docker/serve > mkdir display/site
docker/serve > ls display
docker/serve > cat > display/site/index.html
<html>
  Hello World!
</html>

ctrl + d

cat display/index.html
```

2. _Create docker image_

```
# Create Dockerfile
docker/serve $ touch Dockerfile
docker/serve $ ls
```
- Open the project in code editor
- specify the base image in the Dockerfile
- On the terminal run **docker search node** and use the office node image

```
FROM node:latest
# Install npm globally so the module serve can be access globally
RUN npm install -g serve
# copy the local directory to a local. It will create the directory if it does not exists
COPY ./display ./display
```

3. Serve image

```
FROM node:latest
# Install npm globally so the module serve can be access globally
RUN npm install -g serve
# copy the local directory to a local. It will create the directory if it does not exists
COPY ./display ./display
CMD serve ./display
```

4. Register the image

```
docker build --help

# Build the docker image from local directory
docker build . -t fileserverimage_emma/serve

# Confirm the image is created
docker image ls
```

3. _Create container_

```
docker run --name=serve -p=3001:5000 fileserverimage_emma/serve

# Run the local port on the browser
```

4. _List containers_

```
docker container ls

# Remove the container
docker rm -f container ID
```