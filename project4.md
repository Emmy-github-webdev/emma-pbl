# MEAN STACK DEPLOYMENT TO UBUNTU IN AWS

> Task - In this assignment I implement a simple Book Register web form using MEAN stack

### Step 1: Install NodeJs

* Update ubuntu
- sudo apt update

* Upgrade ubuntu
- sudo apt upgrade

* Add certificates
- sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
- curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

* Install NodeJS
- sudo apt install -y nodejs

### Step 2: Install MongoDB

- sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
- echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

* Install MongoDB
- sudo apt install -y mongodb

* Start The server
- sudo service mongodb start

* Verify that the service is up and running
- sudo systemctl status mongodb
![](images/project4/verify.png)


* Upgrade node to version 14 or above
- curl -sL https://deb.nodesource.com/setup_14.x 565 | sudo -E bash -
- sudo apt-get install -y nodejs

* Install npm – Node package manager (You can jump this step since the step above already installed NPM).
- sudo apt install -y npm

* Install body-parser package
- sudo npm install body-parser

* Create a folder named ‘Books’
- mkdir Books && cd Books
* In the Books directory, Initialize npm project
- cd Books
- npm init

* Add server.js file
- touch server.js
* Open the server.js file and add the following
- vi server.js
- var express = require('express');
- var bodyParser = require('body-parser');
- var app = express();
- app.use(express.static(__dirname + '/public'));
- app.use(bodyParser.json());
- require('./apps/routes')(app);
- app.set('port', 3300);
- app.listen(app.get('port'), function() {
 -   console.log('Server up: http://localhost:' + app.get- ('port'));
- });

### Step 3: Install Express and set up routes to the server
* Install Express mongoose
- sudo npm install express mongoose

* In ‘Books’ folder, create a folder named apps
- mkdir apps
- cd apps

* Create a file named routes.js
- touch routes.js

* Open routes.js and paste the following
- vi routes.js
- var Book = require('./models/book');
- module.exports = function(app) {
  - app.get('/book', function(req, res) {
   -  Book.find({}, function(err, result) {
    -   if ( err ) throw err;
    -   res.json(result);
   -  });
  - }); 
  - app.post('/book', function(req, res) {
  -   var book = new Book( {
   -    name:req.body.name,
    -   isbn:req.body.isbn,
    -   author:req.body.author,
     -  pages:req.body.pages
    - });
   -  book.save(function(err, result) {
   -    if ( err ) throw err;
   -    res.json( {
    -     message:"Successfully added book",
    -     book:result
    -   });
   -  });
 -  });
 -  app.delete("/book/:isbn", function(req, res) {
 -    Book.findOneAndRemove(req.query, function(err, result) {
  -     if ( err ) throw err;
   -   res.json( {
  -      message: "Successfully deleted the book",
   -     book: result
  -    });
  -  });
 - });
 - var path = require('path');
 -  app.get('*', function(req, res) {
   - res.sendfile(path.join(__dirname + '/public', 'index.-html'));
 - });
- };

* In the ‘apps’ folder, create a folder named models
- mkdir models && cd models

* Create a file named book.js
- touch book.js
- vim book.js
* Copy the following and paste
- var mongoose = require('mongoose');
- var dbHost = 'mongodb://localhost:27017/test';
- mongoose.connect(dbHost);
- mongoose.connection;
- mongoose.set('debug', true);
- var bookSchema = mongoose.Schema( {
 -  name: String,
 -  isbn: {type: String, index: true},
  - author: String,
 -  pages: Number
- });
- var Book = mongoose.model('Book', bookSchema);
- module.exports = mongoose.model('Book', bookSchema);

### Step 4 – Access the routes with AngularJS
* Change the directory back to ‘Books’
cd ../..
* Create a folder named public
- mkdir public && cd public

* Add a file named script.js
- touch script.js
* Open script.js nd paste the following
- vi script.js
- var app = angular.module('myApp', []);
- app.controller('myCtrl', function($scope, $http) {
 -  $http( {
  -  method: 'GET',
  -  url: '/book'
  - }).then(function successCallback(response) {
  -  $scope.books = response.data;
  - }, function errorCallback(response) {
   - console.log('Error: ' + response);
 - });
 - $scope.del_book = function(book) {
  -  $http( {
  -    method: 'DELETE',
   -   url: '/book/:isbn',
    -  params: {'isbn': book.isbn}
   - }).then(function successCallback(response) {
    -  console.log(response);
   - }, function errorCallback(response) {
   -   console.log('Error: ' + response);
  -  });
 - };
 - $scope.add_book = function() {
  -  var body = '{ "name": "' + $scope.Name + 
  -  '", "isbn": "' + $scope.Isbn +
  -  '", "author": "' + $scope.Author + 
 -   '", "pages": "' + $scope.Pages + '" }';
-    $http({
 -     method: 'POST',
 -     url: '/book',
 -     data: body
 -   }).then(function successCallback(response) {
  -    console.log(response);
 -   }, function errorCallback(response) {
 -     console.log('Error: ' + response);
  -  });
 - };
- });

* In public folder, create a file named index.html;
- touch index.js

* Open index.js and app the following
- vi index.js
- <!doctype html>
- <html ng-app="myApp" ng-controller="myCtrl">
 - <head>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
    <script src="script.js"></script>
 - </head>
 - <body>
  -  <div>
  -    <table>
        <tr>
          <td>Name:</td>
          <td><input type="text" ng-model="Name"></td>
        </tr>
        <tr>
          <td>Isbn:</td>
          <td><input type="text" ng-model="Isbn"></td>
        </tr>
        <tr>
          <td>Author:</td>
          <td><input type="text" ng-model="Author"></td>
        </tr>
        <tr>
          <td>Pages:</td>
          <td><input type="number" ng-model="Pages"></td>
        </tr>
      </table>
      <button ng-click="add_book()">Add</button>
    </div>
    <hr>
    <div>
      <table>
        <tr>
          <th>Name</th>
          <th>Isbn</th>
          <th>Author</th>
          <th>Pages</th>

        </tr>
        <tr ng-repeat="book in books">
          <td>{{book.name}}</td>
          <td>{{book.isbn}}</td>
          <td>{{book.author}}</td>
          <td>{{book.pages}}</td>

          <td><input type="button" value="Delete" data-ng-click="del_book(book)"></td>
        </tr>
-      </table>
 -   </div>
 - </body>
- </html>

* Change the directory back up to Books
- cd ..
* Start the server by running this command:
- node server.js

![](images/project4/start-sever.png)

* On the browser type the url
- http://3.92.239.160/:3300