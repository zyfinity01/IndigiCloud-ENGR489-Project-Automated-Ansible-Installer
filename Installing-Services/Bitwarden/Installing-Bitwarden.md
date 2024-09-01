# Vaultwarden Installation via Docker

This guide will walk you through the process of installing Vaultwarden using Docker and Docker Compose.

## Prerequisites

- **Docker** and **Docker Compose** are already installed on your system.

## Step-by-Step Installation

### Step 1: Create a Directory for Vaultwarden

Create a directory for your Vaultwarden setup and navigate into it:

```bash
mkdir -p /containers/vaultwarden
cd vaultwarden-docker
```

### Step 2: Create a Docker Compose File

Create a `docker-compose.yml` file inside the `vaultwarden-docker` directory with the following content:

```yaml
version: '3.8'

services:
  vaultwarden:
    image: vaultwarden/server
    container_name: vaultwarden_server
    ports:
      - 8085:80
    environment:
      - ADMIN_TOKEN=your_admin_token
    volumes:
      - /containers/vaultwarden/data:/data
    restart: always
```

Replace `your_admin_token` with a secure token of your choice. This token is used to access the Vaultwarden admin interface.

### Step 3: Start the Container

Run the following command to start the container:

```bash
docker compose up -d
```

This will pull the necessary Docker image, create, and start the container in detached mode.

### Step 4: Access Vaultwarden

Once the container is up and running, you can access Vaultwarden by navigating to `http://localhost:8082` in your web browser.

### Step 5: Secure Vaultwarden with SSL (Optional)

If you want to secure your Vaultwarden instance with SSL, you should place your SSL certificate (`cert.pem`) and key (`key.pem`) files in the `/containers/vaultwarden/ssl` directory. Vaultwarden will automatically use these files to enable HTTPS.

### Step 6: Access the Admin Interface (Optional)

To access the Vaultwarden admin interface, navigate to `http://localhost:8082/admin` and use the `ADMIN_TOKEN` you specified in the environment variables.

## Summary

By following these steps, you should have a fully functional Vaultwarden instance running via Docker. Vaultwarden provides a lightweight, self-hosted password management solution.

