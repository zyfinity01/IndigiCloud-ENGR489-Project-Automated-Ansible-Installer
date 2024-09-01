# iRedMail Installation via Docker

This guide will walk through the process of installing iRedMail using Docker and Docker Compose noting that we are using the "onlyoffice/mailserver" docker container from dockerhub due to it being a more stable and non beta mail server using iRedMail with some advancements via additional features.

## Prerequisites

- **Docker** and **Docker Compose** are already installed on your system.

## Step-by-Step Installation

### Step 1: Create a Directory for iRedMail

Create a directory for your iRedMail setup and navigate into it:

```bash
mkdir -p /containers/iredmail
cd iredmail-docker
```

### Step 2: Create a Docker Compose File

Create a `docker-compose.yml` file inside the `iredmail-docker` directory with the following content:

```yaml
version: '3.8'

services:
  mailserver:
    image: onlyoffice/mailserver
    container_name: iredmail_server
    ports:
      - 25:25
      - 143:143
      - 587:587
      - 993:993
    environment:
      - DB_TYPE=mysql
      - DB_HOST=db
      - DB_NAME=mailserver
      - DB_USER=iredmail
      - DB_PASSWD=77dw8i4yji
      - RSPAMD_PASSWORD=your_rspamd_password
      - MYSQL_ROOT_PASSWORD=0jtvhirxzq
      - DOMAIN=your_domain.com
      - HOSTNAME=mail.your_domain.com
    volumes:
      - /containers/iredmail/mail:/var/vmail
      - /containers/iredmail/clamav:/var/lib/clamav
    restart: always

  db:
    image: mariadb
    container_name: iredmail_db
    environment:
      MYSQL_ROOT_PASSWORD: 0jtvhirxzq
      MYSQL_DATABASE: mailserver
      MYSQL_USER: iredmail
      MYSQL_PASSWORD: 77dw8i4yji
    volumes:
      - /containers/iredmail/dbdata:/var/lib/mysql
    restart: always
```

Replace `your_db_password`, `your_rspamd_password`, `root_password`, `your_domain.com`, and `mail.your_domain.com` with your actual domain and desired passwords.

### Step 3: Start the Containers

Run the following command to start the containers:

```bash
docker compose up -d
```

This will pull the necessary Docker images, create, and start the containers in detached mode.

### Step 4: Access the iRedMail Admin Interface

Once the containers are up and running, you can access the iRedMail admin interface by navigating to `http://mail.your_domain.com` in your web browser.

### Step 5: Complete the Setup

Follow the on-screen instructions to complete the iRedMail setup.

## Summary

By following these steps, you should have a fully functional iRedMail instance running via Docker. Your mail server will handle email delivery, spam filtering, and more.

