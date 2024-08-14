If you want to use your own Nginx installation to handle HTTPS and domain configuration, you can adjust the Docker Compose configuration to exclude the web server configuration and set it up to work behind your own Nginx proxy. Here's how you can modify the guide:

# Jitsi Meet Installation via Docker Compose (Using External Nginx)

This guide will walk you through the process of installing Jitsi Meet using Docker and Docker Compose, while using your own Nginx installation to handle HTTPS and domain configuration.

## Prerequisites

- **Docker** and **Docker Compose** are already installed on your system.
- **Nginx** is installed and configured on your server.

## Step-by-Step Installation

### Step 1: Create a Directory for Jitsi Meet

Create a directory for your Jitsi Meet setup and navigate into it:

```bash
mkdir -p /containers/jitsi/web
mkdir -p /containers/jitsi/prosody
mkdir -p /containers/jitsi/jicofo
mkdir -p /containers/jitsi/jvb
cd /containers/jitsi
```

### Step 2: Create a Docker Compose File

Create a `docker-compose.yml` file inside the `/containers/jitsi` directory with the following content:

```yaml
version: '3.8'

services:
  # Jitsi Meet Frontend
  jitsi_web:
    image: jitsi/web:stable
    container_name: jitsi_web
    restart: unless-stopped
    ports:
      - '8084:80'
    volumes:
      - /containers/jitsi/web:/config
    environment:
      - ENABLE_HTTP_REDIRECT=1
      - ENABLE_HSTS=1
      - XMPP_DOMAIN=meet.jitsi    # Change to your domain
      - XMPP_SERVER=xmpp.meet.jitsi    # Change to your domain
      - PUBLIC_URL=https://meet.jitsi    # Change to your public URL

  # XMPP Server
  jitsi_prosody:
    image: jitsi/prosody:stable
    container_name: jitsi_prosody
    restart: unless-stopped
    expose:
      - '5222'
      - '5347'
      - '5280'
    volumes:
      - /containers/jitsi/prosody:/config
    environment:
      - XMPP_DOMAIN=meet.jitsi    # Change to your domain
      - JICOFO_COMPONENT_SECRET=6o5ykehgngp5    # Change to a secure password
      - JICOFO_AUTH_USER=focus
      - JICOFO_AUTH_PASSWORD=6o5ykehgngp5
      - JVB_AUTH_USER=jvb
      - JVB_AUTH_PASSWORD=6o5ykehgngp5    # Change to a secure password

  # Jicofo (focus component)
  jitsi_jicofo:
    image: jitsi/jicofo:stable
    container_name: jitsi_jicofo
    restart: unless-stopped
    volumes:
      - /containers/jitsi/jicofo:/config
    environment:
      - JICOFO_COMPONENT_SECRET=6o5ykehgngp5    # Change to a secure password
      - JICOFO_AUTH_USER=focus
      - JICOFO_AUTH_PASSWORD=6o5ykehgngp5    # Change to a secure password
      - JVB_AUTH_USER=jvb
      - JVB_AUTH_PASSWORD=6o5ykehgngp5    # Change to a secure password
      - XMPP_DOMAIN=meet.jitsi    # Change to your domain
      - XMPP_SERVER=xmpp.meet.jitsi    # Change to your domain

  # Jitsi Video Bridge
  jitsi_jvb:
    image: jitsi/jvb:stable
    container_name: jitsi_jvb
    restart: unless-stopped
    ports:
      - '10000:10000/udp'
      - '4443:4443'
    volumes:
      - /containers/jitsi/jvb:/config
    environment:
      - XMPP_DOMAIN=meet.jitsi    # Change to your domain
      - JVB_AUTH_USER=jvb
      - JVB_AUTH_PASSWORD=6o5ykehgngp5    # Change to a secure password
      - XMPP_SERVER=xmpp.meet.jitsi    # Change to your domain
      - PUBLIC_URL=https://meet.jitsi    # Change to your public URL
```

### Step 3: Set Up Configuration Directory

Create a configuration directory for Jitsi Meet to store its configurations:

### Step 4: Start the Containers

Run the following command to start the containers:

```bash
docker compose up -d
```

This will pull the necessary Docker images, create and start the containers in detached mode.

### Step 5: Configure Your Nginx

Set up your Nginx configuration to proxy requests to the Jitsi Meet containers. Create an Nginx configuration file, e.g., `/etc/nginx/sites-available/jitsi-meet`, with the following content:

```nginx
server {
    listen 80;
    server_name meet.jitsi;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name meet.jitsi;

    ssl_certificate /path/to/your/cert.crt;
    ssl_certificate_key /path/to/your/cert.key;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # BOSH
    location /http-bind {
        proxy_pass http://localhost:8000/http-bind;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $http_host;
    }

    # Websockets
    location ~ ^/colibri-ws/ {
        proxy_pass http://localhost:8000/colibri-ws/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        tcp_nodelay on;
    }
}
```

Enable the site by creating a symbolic link in the sites-enabled directory:

```bash
sudo ln -s /etc/nginx/sites-available/jitsi-meet /etc/nginx/sites-enabled/
```

### Step 6: Restart Nginx

Restart Nginx to apply the changes:

```bash
sudo systemctl restart nginx
```

### Step 7: Access Jitsi Meet

Once the containers are up and running, you can access Jitsi Meet by navigating to `https://meet.jitsi` in your web browser.

## Summary

By following these steps, you should have a fully functional Jitsi Meet instance running via Docker, with Nginx handling the HTTPS and domain configuration. The web service in the Docker Compose setup will handle the frontend, while Prosody, Jicofo, and JVB manage the backend components of Jitsi Meet.