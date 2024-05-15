## Introduction

Docker will be the main point at which everything runs, from databases to services. this will allow the container layer of services to be heavily controlled, transferrable and portable. this is ontop of the virtual machine layer making IndigiCloud easier to manage.


Certainly! Here's the complete set of commands with each command in its own markdown code block for easy copying and readability:


# Update Your System
```bash
sudo apt-get update
```

# Install Prerequisite Packages
```bash
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
```

# Add Docker’s Official GPG Key
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

# Add Docker Repository
```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

# Update Package Database
```bash
sudo apt-get update
```

# Install Docker
```bash
sudo apt-get install docker-ce
```

<!-- # Install Docker Compose

```
sudo apt  install docker-compose
```

sudo apt install python3-pip -->

# Verify Docker Installation
```bash
sudo systemctl status docker
```

# Check Docker version
```bash
docker --version
```

# Run Docker without `sudo`
```bash
sudo usermod -aG docker ${USER}
```

# Log out and back in, or run:
```bash
su - ${USER}
```

# Verify group membership
```bash
groups
```

Docker is now fully installed.