This document provides a comprehensive explanation of the firewall setup and configuration steps for IndigiCloud. It covers the installation of UFW, the configuration of firewall rules, and the setup of a reverse proxy using Nginx.

---

# UFW Setup Script

This script configures the Uncomplicated Firewall (UFW) on an Ubuntu system. It sets default policies, allows specific ports for SSH, HTTP, HTTPS, and other necessary services, and ensures that the firewall rules are applied.

## Script Overview

```bash
#!/bin/bash

# Enable UFW
ufw --force enable

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
ufw allow 22/tcp

# Allow HTTP and HTTPS for NGINX reverse proxy
ufw allow 80/tcp
ufw allow 443/tcp

# Allow necessary ports for services that require public access
# Example: UFW rule for Jitsi Meet media traffic
ufw allow 10000/udp

# (Add any other necessary ports here based on your research)
# Allow iRedMail ports for email
ufw allow 25/tcp
ufw allow 143/tcp
ufw allow 465/tcp
ufw allow 587/tcp
ufw allow 993/tcp

# Allow SMB port for file sharing
ufw allow 445/tcp

# Reload UFW to apply changes
ufw reload

echo "UFW rules have been set up and applied."
```

## Explanation

### Enable UFW
```bash
ufw --force enable
```
This command enables UFW, ensuring that it is active. The `--force` option bypasses the confirmation prompt.

### Default Policies
```bash
ufw default deny incoming
ufw default allow outgoing
```
These commands set the default policies for UFW. All incoming connections are denied by default, and all outgoing connections are allowed.

### Allow SSH
```bash
ufw allow 22/tcp
```
This command allows incoming SSH connections on port 22, enabling remote management of the server.

### Allow HTTP and HTTPS for NGINX Reverse Proxy
```bash
ufw allow 80/tcp
ufw allow 443/tcp
```
These commands allow incoming HTTP and HTTPS connections on ports 80 and 443, respectively. These will be used for web traffic and will be managed by the NGINX reverse proxy.

### Allow Necessary Ports for Services

#### Jitsi Meet Media Traffic
```bash
ufw allow 10000/udp
```
This command allows incoming UDP connections on port 10000, which is necessary for Jitsi Meet media traffic.

#### iRedMail Email Ports
```bash
ufw allow 25/tcp
ufw allow 143/tcp
ufw allow 465/tcp
ufw allow 587/tcp
ufw allow 993/tcp
```
These commands allow incoming connections on various ports used by iRedMail for email services:
- **Port 25**: SMTP
- **Port 143**: IMAP
- **Port 465**: SMTPS
- **Port 587**: Submission
- **Port 993**: IMAPS

#### SMB File Sharing
```bash
ufw allow 445/tcp
```
This command allows incoming connections on port 445, which is used for SMB file sharing.

### Reload UFW to Apply Changes
```bash
ufw reload
```
This command reloads UFW to ensure all changes are applied.


## Usage


**Execute the script**: Run `sudo ./ufw_setup.sh` to apply the UFW rules.

---
