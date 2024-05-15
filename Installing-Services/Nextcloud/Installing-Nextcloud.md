Sure, I'll adjust the guide accordingly to skip the Docker and Docker Compose installation steps.


# Nextcloud and Nextcloud Calendar Installation via Docker

This guide will walk you through the process of installing Nextcloud using Docker and Docker Compose.

## Prerequisites

- **Docker** and **Docker Compose** are already installed on your system.

## Step-by-Step Installation

### Step 1: Create a Directory for Nextcloud

Create a directory for your Nextcloud setup and navigate into it:

```bash
mkdir -p /containers/nextcloud
cd nextcloud-docker
```

### Step 2: Create a Docker Compose File

Create a `docker-compose.yml` file inside the `nextcloud-docker` directory with the following content:

```yaml
version: '3.8'

services:
  db:
    image: mariadb
    container_name: nextcloud_db
    restart: always
    volumes:
      - /containers/nextcloud/dbdata:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: ukwmles3lhfg
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: ukwmles3lhfg

  app:
    image: nextcloud
    container_name: nextcloud_app
    ports:
      - 8081:80
    depends_on:
      - db
    volumes:
      - /containers/nextcloud/data:/var/www/html
    environment:
      MYSQL_PASSWORD: ukwmles3lhfg
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_HOST: db
```

Adjust the environment variables (`MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`) as needed.

### Step 3: Start the Containers

Run the following command to start the containers:

```bash
docker compose up -d
```

This will pull the necessary Docker images, create and start the containers in detached mode.

### Step 4: Access Nextcloud

Once the containers are up and running, you can access Nextcloud by navigating to `http://localhost:8081` in your web browser.

### Step 5: Complete the Setup

Follow the on-screen instructions to complete the Nextcloud setup.

## Summary

By following these steps, you should have a fully functional Nextcloud instance running via Docker. Your Nginx container will handle the web server and SSL configuration.
