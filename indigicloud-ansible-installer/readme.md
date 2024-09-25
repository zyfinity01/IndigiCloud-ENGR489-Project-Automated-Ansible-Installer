# Ansible Playbook for IndigiCloud

This document serves as a guide for setting up and using the Ansible playbook for the IndigiCloud project. Follow the instructions below to configure the playbook correctly and understand what variables to change and why.

## Prerequisites

- Ensure that you are running an Ubuntu distribution - This setup is designed to be run on Ubuntu-24.04 LTS which is set to be officially supported until april 2034.

- This playbook also assumes that you are able to copy and place this Ansible playbook folder within a directory, either by downloading it as a .ZIP file or by cloning the repository locally.
  To clone this repository,

  - Ensure git is installed:
  
  ```
  sudo apt update
  sudo apt install git
  ```

  - Clone the repository (this will clone it into the directory you are CD'd into):
  
  ```
  git clone https://gitlab.ecs.vuw.ac.nz/engr489/IndigiCloud.git
  ```

## Navigating to the indigicloud folder and editing configs

Firstly navigate to the folder that you cloned in the previous step by using ``cd``, the desired folder will be ``indigicloud-ansible-installer/`` and you can use ``nano global_vars.yml`` to edit the configuration variables. Many of these variables are setup by default, however some need to be changed such as the boolean true/false for if you confirm the variables are correct, and manually changing the cloudflare details based on your cloudflare account.

## Cloudflare setup:

To manually grab your Cloudflare API details, follow these steps:

1. **Log in to your Cloudflare account.**
2. **Navigate to the API Tokens section:**
   - Go to the **My Profile** section by clicking on your profile icon in the top right corner.
   - Select **API Tokens** from the left sidebar.
   - Click on **view** for the Global API Key
3. **Copy your API key:**
   - Once created, copy the API token as you will need it for the `cloudflare_api_key` variable.
4. **Email Address:**
   - Use the email address associated with your Cloudflare account for the `cloudflare_email` variable.
5. **Zone:**
   - The zone refers to the domain you are managing with Cloudflare. Ensure you specify the correct primary domain in the `cloudflare_domain` variable. This is crucial for the playbook to function correctly as it will manage DNS records and SSL certificates for this domain.

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
