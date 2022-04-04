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

