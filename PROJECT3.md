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
![image](images/project3/startserver.png)
![](images/project3/startserver.png)

### Add custom TCP port 5000  to the EC2 instance

### On the browser type the url
- http://<PublicIP-or-PublicDNS>:5000

![image](images/project3/welcometoexperess.png)

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

## Create mongo DB database
## Create .env file in the root diretcory
	- Touch .env
	- Vim .env
## Add the connection to the mongoDB
	- DB = 'mongodb+srv://<username>:<password>@<network-address>/<dbname>?retryWrites=true&w=majority'
## Update the index.js file 

	- const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const routes = require('./routes/api');
const path = require('path');
require('dotenv').config();
const app = express();
const port = process.env.PORT || 5000;
//connect to the database
mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log(`Database connected successfully`))
.catch(err => console.log(err));
//since mongoose promise is depreciated, we overide it with node's promise
mongoose.Promise = global.Promise;
app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});
app.use(bodyParser.json());
app.use('/api', routes);
app.use((err, req, res, next) => {
console.log(err);
next();
});
app.listen(port, () => {
console.log(`Server running on port ${port}`)
});
## Start the server and you should see message, Database connected successfully

![image](images/project3/postman.png)

> Step 4 – Frontend creation

### create react app
- npx create-react-app client

### Install concurently and nodemon
- npm install concurrently nodemon --save-dev

### In the todo folder, update the scripts part of the package.json
- "scripts": {
"start": "node index.js",
"start-watch": "nodemon index.js",
"dev": "concurrently \"npm run start-watch\" \"cd client && npm start\""
}


### change directory to client 
- Cd client
### Open package.json and add proxy
	- Vim package.json
	- "proxy": "http://localhost:5000"
### change directory to todo folder and start the application
	- Npm run dev
### TCP port 3000 on EC2 by adding a new Security Group rule.

## Create React Components

### Change directory to client folder
	- Cd client
	- Cd src
	- Mkdir components
	- Cd components
	- Touch Input.js ListTodo.js Todo.js
### Open Input.js and paste the content below
	- Vim Input.js
	import React, { Component } from 'react';
import axios from 'axios';
	class Input extends Component {
	state = {
action: ""
}
	addTodo = () => {
const task = {action: this.state.action}
	if(task.action && task.action.length > 0){
      axios.post('/api/todos', task)
        .then(res => {
          if(res.data){
            this.props.getTodos();
            this.setState({action: ""})
          }
        })
        .catch(err => console.log(err))
    }else {
      console.log('input field required')
    }
	}
	handleChange = (e) => {
this.setState({
action: e.target.value
})
}
	render() {
let { action } = this.state;
return (
<div>
<input type="text" onChange={this.handleChange} value={action} />
<button onClick={this.addTodo}>add todo</button>
</div>
)
}
}
	export default Input
	
### Change to client folder and install axios
	- Cd ..
	- Cd ..
	- Npm install axios
### change to the component directory and update the ListTodo.js with content below

	- Cd src/components
	- Vim ListTodo.js
	- import React from 'react';
	const ListTodo = ({ todos, deleteTodo }) => {
	return (
<ul>
{
todos &&
todos.length > 0 ?
(
todos.map(todo => {
return (
<li key={todo._id} onClick={() => deleteTodo(todo._id)}>{todo.action}</li>
)
})
)
:
(
<li>No todo(s) left</li>
)
}
</ul>
)
}
	export default ListTodo
	Then in your Todo.js file you write the following code
	import React, {Component} from 'react';
import axios from 'axios';
	import Input from './Input';
import ListTodo from './ListTodo';
	class Todo extends Component {
	state = {
todos: []
}
	componentDidMount(){
this.getTodos();
}
	getTodos = () => {
axios.get('/api/todos')
.then(res => {
if(res.data){
this.setState({
todos: res.data
})
}
})
.catch(err => console.log(err))
}
	deleteTodo = (id) => {
	axios.delete(`/api/todos/${id}`)
      .then(res => {
        if(res.data){
          this.getTodos()
        }
      })
      .catch(err => console.log(err))
	}
	render() {
let { todos } = this.state;
	return(
      <div>
        <h1>My Todo(s)</h1>
        <Input getTodos={this.getTodos}/>
        <ListTodo todos={todos} deleteTodo={this.deleteTodo}/>
      </div>
    )
	}
}
	export default Todo;
	
### Edit the App.js file
	- import React from 'react';
	import Todo from './components/Todo';
import './App.css';
	const App = () => {
return (
<div className="App">
<Todo />
</div>
);
}
	export default App;

### Edit App.css
	- .App {
text-align: center;
font-size: calc(10px + 2vmin);
width: 60%;
margin-left: auto;
margin-right: auto;
}
input {
height: 40px;
width: 50%;
border: none;
border-bottom: 2px #101113 solid;
background: none;
font-size: 1.5rem;
color: #787a80;
}
input:focus {
outline: none;
}
button {
width: 25%;
height: 45px;
border: none;
margin-left: 10px;
font-size: 25px;
background: #101113;
border-radius: 5px;
color: #787a80;
cursor: pointer;
}
button:focus {
outline: none;
}
ul {
list-style: none;
text-align: left;
padding: 15px;
background: #171a1f;
border-radius: 5px;
}
li {
padding: 15px;
font-size: 1.5rem;
margin-bottom: 15px;
background: #282c34;
border-radius: 5px;
overflow-wrap: break-word;
cursor: pointer;
}
@media only screen and (min-width: 300px) {
.App {
width: 80%;
}
input {
width: 100%
}
button {
width: 100%;
margin-top: 15px;
margin-left: 0;
}
}
@media only screen and (min-width: 640px) {
.App {
width: 60%;
}
input {
width: 50%;
}
button {
width: 30%;
margin-left: 10px;
margin-top: 0;
}
}

### Edit Index.css

	- body {
margin: 0;
padding: 0;
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
"Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
box-sizing: border-box;
background-color: #282c34;
color: #787a80;
}
code {
font-family: source-code-pro, Menlo, Monaco, Consolas, "Courier New",
monospace;
}


![image](images/project3/complete.png)


