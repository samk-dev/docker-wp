# Docker WP

Local development setup for WordPress using Docker && Docker Compose with Nginx - PHP-FPM - MySql - PHP MyAdmin - Mailhog - Self-Signed SSL Certificates

## Getting Started

We should set our enviornment variables and generate our self-signed ssl certificates. _If you don't want to enable ssl certificates please comment or remove the follwoing code to avoid errors. `docker-compose.yml` lines: 13 and 18 - `etc/config/nginx.conf` lines: 83 to the end of file_

We adjust the variables in .env to suite our project the default ports are:

-   Ngnix Http: 80
-   Ngnix Https: 443
-   PHP-FPM: 9001
-   MySql: 3306
-   PHP MyAdmin: 8080
-   Mailhog Server: 1025
-   Mailhog UI: 8025
-   Portainer: 8000

### Preparing Stuff

```bash
# Clone the repository
git clone git@github.com:samk-dev/docker-wp.git

# Navigate to docker-wp
cd docker-wp

# Rename .env-example to .env
mv .env-example .env

## Generate Self-Signed SSL Certificate ##
## This is not required if you don't need https and you did comment/remove the ssl settings ##

# Navigate to scripts/
cd etc/scripts/

# Give excution permissions to the script
chmod u+x self-signed-init.sh

# Execute the script
./self-signed-init.sh localhost

# Navigate to etc/
cd ..

# Move certificates to etc/certs/live/localhost
mv cert.pem certs/live/localhost/fullchain.pem
mv key.pem certs/live/localhost/privkey.pem
```

### Starting Up Containers

from the project root run `docker-compose up -d` this will build and run the containers. Prepare yourself a ☕️ because it will take some time

**From any web browser access:**

-   Webserver HTTP - [http://localhost:${PORT_NGINX}](http://localhost)
-   Webserver HTTPS - [https://localhost:${PORT_NGINX}](https://localhost) - you may get a broswer alert of an insecure content, just press proceed anyway. On chrome sometimes you may not see the proceed button anyway, you can find a fix here: [Bypass invalid certificate in chrome - NET::ERR_CERT_INVALID error](https://dblazeski.medium.com/chrome-bypass-net-err-cert-invalid-for-development-daefae43eb12)
-   PHP MyAdmin - [http://localhost:${PORT_PHP_MYADMIN}](http://localhost:8080)
-   Mailhog - [http://localhost:${PORT_MAILHOG_UI}](http://localhost:8025)
-   Portainer - [http://localhost:${PORT_MAILHOG_UI}](http://localhost:8025)

## Connect to the Database

The variables refrenced in the examples are the values you set in .env @ project root

### wp-config.php

_When running `docker-compose up` the first install will already fill the db credentials for you, so if you want to modify change the wp-config settings_

```php
/** MySQL settings - You can get this info from your web host **/

/** The name of the database for WordPress */
define( 'DB_NAME', $MYSQL_DATABASE );

/** MySQL database username */
define( 'DB_USER', $MYSQL_ROOT_USER );

/** MySQL database password */
define( 'DB_PASSWORD', $MYSQL_ROOT_PASSWORD );

/** MySQL hostname */
define( 'DB_HOST', '<container_name>:<container_port>' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );
```

### Connect to the Database using PHP MyAdmin

-   Server: mysql:${PORT_MYSQL}
-   Username: ${MYSQL_ROOT_USER}
-   Password: ${MYSQL_ROOT_PASSWORD}

### Connect to the Database using database clients like Table Plus

-   Host: 127.0.0.1
-   Port: ${PORT_MYSQL}
-   Database: ${MYSQL_DATABASE}
-   User: ${MYSQL_ROOT_USER}
-   Password: ${MYSQL_ROOT_PASSWORD}

## Access containers shell:

You can access any container shell by using the command `docker exec -it ${CONTAINER_NAME} sh` and `exit` to exit

_Example by installing [Sage Starter Theme by the guys @ root.io](https://roots.io/sage/):_

```bash
# Access WP container
docker exec -it docker-wp-wp sh

# Navigate to wp-content/themes
cd wp-content/themes

# Install Sage
composer create-project roots/sage your-theme-name

# Navigate to your-theme-name
cd your-theme-name

# Install all the necessary dependencies to run the build process
yarn
# OR
npm install
```

### Mailhog Configuration

-   Install [WordPress Mail SMTP Plugin](https://wordpress.org/plugins/wp-mail-smtp/)
-   Navigate to WP Mail SMTP > Settings and Select PHP as mailer option
-   Navigate to WP Mail SMTP > Tools > Email Test
    in Send To set the address to `dev@mailhog.local` as a result you'de see a warning, ignore it and check mailhog to see the email

### Xdebug Configuration

-   Inside `etc/config/wordpress.ini` change `xdebug.remote_host` to your local machine ip address
-   Restart appserver container `docker restart appserver` _if you changed the service name make sure to refrence it instead of appserver_
-   From php/wp container shell run `php -i | grep Xdebug` you should see xdebug version ++ more information
