# Multi Tier Web Application stack

## Introduction

It is a web site created in Java consisting of multiple services(MySql server, Memcache, rabitMQ, Nginx, tomcat) deployed in five different virtual machines.

### Services

#### Nginx: 
It is an open-source web server that also function as _reverse proxy_, _content cache_, _load balancer_, _TCP/UDP server_, and _mail proxy server_. Nginx runs on port 80 by default.

##### Why Nginx?

It is known for it's flexibility and high performance with low resource utilization.

![Reverse Proxy](/images/nginx1.png)

##### Nginx VS Apache

| Feature | Nginx | Apache |
| :-:     | :-:   | :-:    |
| Architecture | Event-driven(Asynchronus) | Process/thread-based |
| Performance | High concurency, fast | Slower with many connections |
| Memory Usage | Low | High |
| Static content | Extremely Fast | Good |
| Config format | Sumple and declarative | More flexible but complex |
| Use case | Web server, LB, reverse proxy, content cache, etc | Traditional web server |

DevOps Engineers often choose NGINX for its:

- Lightweight footprint
- Ease of automation
- Docker/Kubernetes friendliness

##### Use Cases

| Use Case | Example |
| :-:      | :-:     |
| Web server | serving static applications (React/Angular) |
| Reverse Proxy | Forwarding requests to backend apps (Node.js, Java, Python) |
| Load Balancer | Distributing load between backend servers |
| SSl termination | Handling HTTPS at the edge |
| Caching | Reduce load on upstream services |
| Ingress Controller (Kubernetes) | Managing traffic inside Kubernetes clusters |
| Rate limiting and security enforcement | protecting API from abuse or bots |

##### Install Nginx

- On Ubuntu/Debian
```
sudo apt update
sudo apt install nginx -y
```
- On RHEL/CentOS
```
sudo yum install epel-release -y
sudo yum install nginx -y
```

##### Nginx File Structure

| File/Directory | Purpose |
| :-:            | :-:     |
| /etc/nginx/nginx.conf | Main configuration file |
| /etc/nginx/sites-availables/ | Stores virtual host (server block) config |
| /etc/nginx/sites-availables/default | Default config file pointing to the web root |
| /etc/nginx/sites-enabled/ | Sysmlinks to active site configs |
| /var/www/html | Default web root directory (static web files) |

| /var/log/nginx/ | Contains access and error logs |

##### Basic Config

```
server {
    listen 80;
    server_name localhost;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```
##### Where:
- listen 80; → Listens on HTTP port 80
- server_name localhost; → Domain or IP to respond to
- root → Path where NGINX looks for files
- index → Default file to serve (usually index.html)
- location / → URL path handling

##### Common Error and Fixes

| Error | Solution |
| :-:   | :-:      |
| 403 Forbidden | Check file permissions (use chmod/cown) |
| 404 Not found | Ensure correct root or alias |
| Nginx not reloading changes | Ensure sudo nginx -s reload or restart Nginx |
| Port already in use | Use sudo lsof =i :80 to identify process |

##### Configure Nginx as reverse proxy
In this case, the nodejs application is running on port 3000 in the localhost as the nginx.

update the _/etc/nginx/sites-available/default_

```
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

##### Where:
- proxy_pass → forwards requests to your backend app
- proxy_set_header → preserves original request metadata (like IP and host)

##### Configure Nginx as Load balancing

By default Nginx as load balancer uses Round Robin approach to distribute load between servers. Other options are least_conn, and ip_hash.

update the _/etc/nginx/sites-available/default_

```
# By default, it's using Round Robin

upstream backend_app {
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://backend_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```
# Using least_conn

upstream backend_app {
    leat-conn;
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://backend_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

##### Configure Nginx as SSL

update the _/etc/nginx/sites-available/default_

```
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Optional: Redirect HTTP to HTTPS
server {
    listen 80;
    server_name localhost;
    return 301 https://$host$request_uri;
}
```

##### SSL File Path

| Path | Purpose |
| :-:  | :-:     |
| /etc/ssl/certs/nginx-selfsigned.crt | SSL certificate |
| /etc/ssl/private/nginx-selfsigned.key | Private key |
| /etc/nginx/sites-available/default | HTTPS proxy config |