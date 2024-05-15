## Introduction

We will be running Silverstripe CMS as a docker container alongside it's associated database.

## Prerequisite

Ensure that the directory ``/containers/silverstripe`` is created
```
sudo mkdir -p /containers/silverstripe
```

## Installation 

Docker compose file for both the database and the frontend containers:
These files create the docker containers, set the directories being used on the host in the volume parameters, here they have been set to ``/containers/silverstripe/xxx``, where ``xxx`` is either ``dbdata`` or ``silverstripedata``:

Use ``sudo nano /containers/silverstripe/docker-compose.yaml`` to create and paste the following compose file data: 
```
version: "3.8"
services:
  silverstripe:
    image: brettt89/silverstripe-web:8.1-apache
    volumes:
       - /containers/silverstripe/silverstripedata:/var/www/html
    depends_on:
       - database
    environment:
       - DOCUMENT_ROOT=/var/www/html/public
       - SS_TRUSTED_PROXY_IPS=*
       - SS_ENVIRONMENT_TYPE=dev
       - SS_DATABASE_SERVER=database
       - SS_DATABASE_NAME=SS_mysite
       - SS_DATABASE_USERNAME=root
       - SS_DATABASE_PASSWORD=
       - SS_DEFAULT_ADMIN_USERNAME=admin
       - SS_DEFAULT_ADMIN_PASSWORD=password
    ports:
     - "8080:80"

  database:
    image: mysql:5.7
    environment:
       - MYSQL_ALLOW_EMPTY_PASSWORD=yes
    volumes:
       - /containers/silverstripe/dbdata:/var/lib/mysql
```

Create the ``Dockerfile`` in the same directory using ``nano Dockerfile``:
```
FROM brettt89/silverstripe-web:8.1-apache
ENV DOCUMENT_ROOT /var/www/html/public

COPY . $DOCUMENT_ROOT
WORKDIR $DOCUMENT_ROOT
```

Build the services defined in the docker-compose file:
```
docker compose up --build -d
```


Lists the status of all containers and copy the id for the silverstripe container:
```
docker ps
```

Opens a bash shell in the silverstripe container:

```
docker exec -it <containerid> bash 
```

Delete all example files in /var/www:

```
rm -rf .*
```

Now we want to install composer which is a php service that will install inside the SilverStripe CMS container:
Run each of the following lines which in order will:
- Download the installer to the current directory
- Verify the installer SHA-384, which you can also [cross-check here](https://composer.github.io/pubkeys.html)
- Run the installer
- Remove the installer
```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```
Now move composer to the path of the container:
```
mv composer.phar /usr/local/bin/composer
```

Ensure correct permissions inside container:

```
chown -R www-data:www-data /var/www
```

Installs SilverStripe project in! the container

```
composer create-project silverstripe/installer .
```

Now again ensure correct permissions inside container:

```
chown -R www-data:www-data /var/www
```

## Last step inside the container

Now exit the containers bash enviroment using ``exit``

## Additional step to imcrease file upload limits to 999MB while still inside the container:

Grab docker id for silverstripe container with ``docker ps``

```
cat <<EOF > php.ini
; Maximum allowed size for uploaded files.
upload_max_filesize = 999M
post_max_size = 999M
EOF
docker cp php.ini <containerid>:/usr/local/etc/php/php.ini
```



## Now to build the database visit here:
Note that localhost is only valid if you are using a browser in the VM, if not then use the IP address of the VM via your administration computer instead of ``localhost``.

``http://localhost:8080/dev/build``

## Complete

Now Silverstripe CMS should be installed and accessible via port 8080 on the host machine.

``http://localhost:8080``

And with the user ``admin`` and pass ``password`` at:

``http://localhost:8080/admin``
