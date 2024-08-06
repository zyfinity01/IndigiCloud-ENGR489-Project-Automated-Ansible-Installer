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
