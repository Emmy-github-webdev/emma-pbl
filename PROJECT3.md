# (STEP 5) PROJECT 3: MERN STACK IMPLEMENTATION

> STEP 1 – BACKEND CONFIGURATION

### Update Ubuntu
- sudo apt update

### Upgrade Ubunto
- sudo apt upgrade

### Get the location of Node.js software from Ubuntu repositories
- curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

### Install Node.js
- sudo apt-get install -y nodejs

### Verify the Node installation
- Node -v

### Verify the npm installation
Npm -v

## Application Code Setup

### Create a new directory for your To-Do project:
-mkdir Todo

### Change directory to the Todo folder and initialize the project
- Cd Todo
- Npm init
- Ls - to confirm package.json was created

> STEP 2 - INSTALL EXPRESSJS

### Install express using NPM
- npm install express

### Create index.js file
- touch index.js
- Ls - to check

### Install Dotenv
- npm install dotenv

### Open index.js file
- vim index.js

### Add the following content to the index.js
- const express = require('express');
require('dotenv').config();
const app = express();
const port = process.env.PORT || 5000;
app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});
app.use((req, res, next) => {
res.send('Welcome to Express');
});
app.listen(port, () => {
console.log(`Server running on port ${port}`)
});

### Start the server
- node index.js

### Add custom TCP port 5000  to the EC2 instance

### On the browser type the url
- http://<PublicIP-or-PublicDNS>:5000

## Routes

* Our todo should be able to
	- Create a new task
	- Display list of all task
	- Delete a completed task
### Create routes folder
- mkdir routes

### Create API.js file in the routes folder
	- cd routes
	- Touch api.js
### Open api.js file and paste the following
	- vim api.js
	- const express = require ('express');
const router = express.Router();
	router.get('/todos', (req, res, next) => {
	});
	router.post('/todos', (req, res, next) => {
	});
	router.delete('/todos/:id', (req, res, next) => {
	})
	module.exports = router;

> SETP 3 -  MODELS

### Change directory to Todo folder and install mongoose
	- Cd ..
	- npm install mongoose
### Create model folder
	- mkdir models
### Change directory to models and create todo.js file
	- Cd models
	- Touch todo.js
### Open the todo.js file and paste the following
	- Vim todo.js
- 	const mongoose = require('mongoose');
const Schema = mongoose.Schema;
	//create schema for todo
const TodoSchema = new Schema({
action: {
type: String,
required: [true, 'The todo text field is required']
}
})
	//create model for todo
const Todo = mongoose.model('todo', TodoSchema);
	module.exports = Todo;
	
### Update api.js in  routes 
- const express = require ('express');
const router = express.Router();
const Todo = require('../models/todo');
router.get('/todos', (req, res, next) => {
//this will return all the data, exposing only the id and action field to the client
Todo.find({}, 'action')
.then(data => res.json(data))
.catch(next)
});
router.post('/todos', (req, res, next) => {
if(req.body.action){
Todo.create(req.body)
.then(data => res.json(data))
.catch(next)
}else {
res.json({
error: "The input field is empty"
})
}
});
router.delete('/todos/:id', (req, res, next) => {
Todo.findOneAndDelete({"_id": req.params.id})
.then(data => res.json(data))
.catch(next)
})
module.exports = router;



