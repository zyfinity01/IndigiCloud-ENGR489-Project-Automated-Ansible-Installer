# Ansible Playbook for IndigiCloud

This document serves as a guide for setting up and using the Ansible playbook for the IndigiCloud project. Follow the instructions below to configure the playbook correctly and understand what variables to change and why.

## Prerequisites
Ensure that you are running an Ubuntu distribution - This setup is designed to be run on Ubuntu-24.04 LTS which is set to be officially supported until april 2034.

This playbook also ensures that you are able to copy and place this Ansible playbook folder within a directory, either by downloading it as a .ZIP file or by cloning the repository locally.

## Configuration Instructions

### Editing `global_vars.yml`
The `global_vars.yml` file includes essential configuration variables. Below is a summary of the key variables:

#### General Setup
- **`variables_initialized`**: Set to `true` when all necessary configurations have been made. This helps prevent accidental overwrites.

#### Certbot Variables
- **`certbot_email`**: Your email for Let's Encrypt notifications.
- **`certbot_domains`**: Domains for obtaining SSL certificates. Usually set to a wildcard (e.g., `*.{{ cloudflare_domain }}`).
- **`certbot_staging`**: Set to `true` for testing; use `false` for production use.

#### Cloudflare Variables
- **`cloudflare_api_key`**: Your Cloudflare API key.
- **`cloudflare_email`**: The email associated with your Cloudflare account.
- **`cloudflare_domain`**: The primary domain managed via Cloudflare.
- **`your_server_ip`**: Your server's public IP address.

#### Service-Specific Variables
- **Silverstripe**:  
  - **`silverstripe_db_name`**: Name of the database for Silverstripe.
  - **`silverstripe_db_user`**: Database user, often `root`.
  - **`silverstripe_db_password`**: Password for the database user.
  - **`silverstripe_admin_user`**: Admin username for Silverstripe.
  - **`silverstripe_admin_password`**: Admin password.

- **Nextcloud**:  
  - **`nextcloud_db_root_password`**: Root password for the Nextcloud database.
  - **`nextcloud_db_name`**: Name of the Nextcloud database.
  - **`nextcloud_db_user`**: User for the Nextcloud database.
  - **`nextcloud_db_password`**: Password for the Nextcloud database user.

- **Mattermost**:  
  - **`mattermost_db_user`**: User for the Mattermost database.
  - **`mattermost_db_password`**: Password for the Mattermost database.
  - **`mattermost_db_name`**: Database name for Mattermost.

Make sure to fill in these variables according to your project's specifics.

## Running the Playbook
Once you've edited the variables, you can run the playbook using the bash script:  
```bash  
bash run_playbook.sh  
```  
This script checks for Ansible installation, installs it if absent, and runs the main playbook.

### Important Considerations
- Be cautious when modifying the `global_vars.yml` file, as improper settings may lead to configuration issues.
- On subsequent runs, if prompted to confirm changes, ensure that you are aware of what modifications you are making to avoid unwanted changes.

## Conclusion
Following this guide will help you correctly set up and utilize the Ansible playbook for your IndigiCloud project. If you encounter any issues, please refer to service-specific documentation or troubleshoot based on the error messages you receive.