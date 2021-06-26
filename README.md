# Docker WP

Local development setup for WordPress using Docker && Docker Compose with Nginx - PHP-FPM - MySql - PHP MyAdmin - Mailhog

## Getting Started

### Starting Up Containers

from the project root run `docker-compose up -d` this will build and run the containers. Prepare yourself a ☕️ because it will take some time

**From any web browser access:**

HTTP - [http://localhost:${PORT_NGINX}](http://localhost) - you should see a php info page

PHP MyAdmin - [http://localhost:${PORT_PHP_MYADMIN}](http://localhost:8080)

Mailhog - [http://localhost:${PORT_MAILHOG_UI}](http://localhost:8025)

## Connect to the Database using PHP MyAdmin

**Login Credentials:**

-   Server: mysql:${PORT_MYSQL}
-   Username: ${MYSQL_ROOT_USER}
-   Password: ${MYSQL_ROOT_PASSWORD}

## Connect to the Database using database clients like Table Plus

**Login Credentials:**

-   Host: 127.0.0.1
-   Port: ${PORT_MYSQL}
-   Database: ${MYSQL_DATABASE}
-   User: ${MYSQL_ROOT_USER}
-   Password: ${MYSQL_ROOT_PASSWORD}

## Access containers shell:

ngnix container: `docker exec -it ${CONTAINER_NAME} sh`

mysql container: `docker exec -it ${CONTAINER_NAME} sh`

php container: `docker exec -it ${CONTAINER_NAME} sh`

### Mailhog Configuration

-   Install (WordPress Mail SMTP Plugin)[https://wordpress.org/plugins/wp-mail-smtp/]
-   Navigate to WP Mail SMTP > Settings and Select PHP as mailer option
-   Navigate to WP Mail SMTP > Tools > Email Test
    in Send To set the address to `dev@mailhog.local` as a result you'de see a warning, ignore it and check mailhog to see the email

### Xdebug Configuration

-   Inside `etc/config/wordpress.ini` change `xdebug.remote_host` to your local machine ip address
-   From php/wp container shell run `php -i | grep Xdebug` you should see xdebug version ++ more information
