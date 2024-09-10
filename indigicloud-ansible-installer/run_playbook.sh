#!/bin/bash

# Define the playbook file name
PLAYBOOK_FILE="main.yml"
COLLECTION="community.general"

# Function to check if Ansible is installed
is_ansible_installed() {
    if command -v ansible >/dev/null 2>&1; then
        return 0  # Ansible is installed
    else
        return 1  # Ansible is not installed
    fi
}

# Function to install Ansible
install_ansible() {
    echo "Ansible is not installed. Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
}

# Function to check if the Ansible collection is installed
is_collection_installed() {
    if ansible-galaxy collection list | grep -q "$COLLECTION"; then
        return 0  # Collection is installed
    else
        return 1  # Collection is not installed
    fi
}

# Function to install the Ansible collection
install_collection() {
    echo "The '$COLLECTION' collection is not installed. Installing..."
    ansible-galaxy collection install community.general
}

# Function to run the playbook
run_playbook() {
    if [ -f "$PLAYBOOK_FILE" ]; then
        echo "Running the Ansible playbook..."
        ansible-playbook "$PLAYBOOK_FILE"
    else
        echo "Error: Ansible playbook '$PLAYBOOK_FILE' not found."
        exit 1
    fi
}

# Main logic
if is_ansible_installed; then
    echo "Ansible is already installed."
else
    install_ansible
fi

# Check and install the required Ansible collection
if is_collection_installed; then
    echo "The '$COLLECTION' collection is already installed."
else
    install_collection
fi

# Run the playbook
run_playbook
