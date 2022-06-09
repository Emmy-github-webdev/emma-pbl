### Build an express.js image

1. _Create project directory and docker image_
- Create a folder **docker**
- Change directory to **docker** folder
```
mkdir docker
cd docker
docker $ mkdir express
docker $ cd express
docker/express $ touch Dockerfile
docker/express $ touch package.json
docker/express $ touch server.js
```
2. Open it in visual code editor
_Add the code below to **server.js** file_
```
const express = require('express);
const app = express();
const HOST = '0.0.0.0';
const PORT = 80;

app.get('/', (req, res) => {
  res.send('Hello world');
});

app.listen(PORT, HOST);

console.log(`Running on http://${HOST}:${PORT}`);
```

_Add the code below to **package.json** file_

```
{
  "dependencies": {
    "express": "^4.16.1"
  }
}
```

_Add the code below to **Dockerfile** file_

```
FROM node
COPY . .
RUN npm install
CMD ["node", "server.js"]

```

_Build the image_

```
docker build . -t emma/express
docker image ls
```

3. _Create container_

```
docker run --name=express -p=3002:80 emma/express

# Run the local port on the browser
```

4. _List containers_

```
docker container ls

# Remove the container
docker rm -f container ID
```

