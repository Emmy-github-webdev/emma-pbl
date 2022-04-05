# PROJECT 2: LEMP STACK IMPLEMENTATION

> Step 1 – Installing the Nginx Web Server
- Update the server using apt package manager
sudo apt update
- Install Nginx server
sudo apt install nginx
- Verify that Nginx server successfuly installed.  It should be green and running
sudo systemctl status nginx.
[](images/project2/1-active-nginx.png)
-  Add a rule to EC2 configuration to open inbound connection through port 80
- Access it locally in our Ubuntu shell (curl http://localhost:80
or
curl http://127.0.0.1:80)
[](images/project2/2-access-nginx-locally.png)
-Another way to retrieve your Public IP address, other than to check it in AWS Web console, is to use following command:
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
- Open a web browser to access the following url
[](images/project2/3-access-nginx-browser.png)

> Step 2 — Installing MySQL
- Install MySql using apt
sudo apt install mysql-server
- Run a security script that comes pre-installed with MySQL
sudo mysql_secure_installation
-Test if you’re able to log in to the MySQL console by typing:
sudo mysql
[](images/project2/4-test-msql-connection.png)
- Exit MySql console
exit

> STEP 3 – INSTALLING PHP

- Install PHP 
sudo apt install php-fpm php-mysql

> Step 4 — Configure Nginx to Use PHP Processor
- Create the root web directory for your_domain:
sudo mkdir /var/www/projectLEMP
- Assign ownership of the directory with the $USER environment variable, which will reference your current system user:
sudo chown -R $USER:$USER /var/www/projectLEMP
- Open a new configuration file in Nginx’s sites-available directory
-  Paste in the following bare-bones configuration:

#/etc/nginx/sites-available/projectLEMP

server {
    listen 80;
    server_name projectLEMP www.projectLEMP;
    root /var/www/projectLEMP;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}

[](images/project2/5-edit-config-file.png)

- Activate your configuration by linking to the config file from Nginx’s sites-enabled directory:
sudo ln -s /etc/nginx/sites-available/projectLEMP /etc/nginx/sites-enabled/
- Test your configuration for syntax errors by typing:
sudo nginx -t

[](images/project2/6-nginx connected.png)

- Disable default Nginx host that is currently configured to listen on port 80, for this run:
sudo unlink /etc/nginx/sites-enabled/default
- Reload Nginx to apply the changes:
sudo systemctl reload nginx
- The new website is now active, but the web root /var/www/projectLEMP is still empty. Create an index.html file in that location and test new server block works as expected:

sudo echo 'Hello LEMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/projectLEMP/index.html

- Refresh the URL
[](images/project2/7-fresh.png)

> STEP 5 – TESTING PHP WITH NGINX
- Create a test PHP file in the document root:
sudo nano /var/www/projectLEMP/info.php
- Paste the following line:
<?php
phpinfo();

- Access the page in your browser:
http://`server_domain_or_IP`/info.php

> Step 6 - RETRIEVING DATA FROM MYSQL DATABASE WITH PHP

- Connect MySql:
sudo mysql
- Create Database:
mysql> CREATE DATABASE `example_database`;
- Create User:
CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
- Grant user permission on the DB
- GRANT ALL ON example_database.* TO 'example_user'@'%';
- Exit

- Test if the user has a proper permission by logging in:
mysql -u example_user -p
- Show database:
SHOW DATABASES;

- Create table todo_list:
CREATE TABLE example_database.todo_list (
mysql>     item_id INT AUTO_INCREMENT,
mysql>     content VARCHAR(255),
mysql>     PRIMARY KEY(item_id)
mysql> );

- Insert a row

mysql> INSERT INTO example_database.todo_list (content) VALUES ("My first important item");

- Select the table:
SELECT * FROM example_database.todo_list;