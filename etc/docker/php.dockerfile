# Install WordPress with PHP-FPM Alpine
FROM wordpress:5.7.2-php7.4-fpm-alpine

# Install Alpine Packages
RUN apk add --update python3 python3-dev make cmake gcc g++ git pkgconf unzip wget py-pip build-base gsl libavc1394-dev libjpeg libjpeg-turbo-dev libpng-dev libdc1394-dev clang tiff-dev libwebp-dev linux-headers

# Install soap and xml extensions
RUN set -ex && apk --no-cache add \
    libxml2-dev \
    php7-simplexml \
    php7-xml
RUN docker-php-ext-install soap

# Install some tools
RUN apk update \
    && apk add less vim nano \
    msmtp \
    && apk add -u musl

# Append path automatically so that user doesn't have to
ADD etc/scripts/wp /usr/local/bin/wp

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp-cli && chmod +x /usr/local/bin/wp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install && Configure sendmail
RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x /usr/local/bin/mhsendmail  

RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailserver:1025 --from=no-dev@mailhog.dev"' > /usr/local/etc/php/conf.d/mailhog.ini

# Install xdebug
RUN apk --update --no-cache add autoconf g++ make && \
    pecl install -f xdebug && \
    docker-php-ext-enable xdebug

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /var/www/html

# Set read && write permissions
RUN chmod 777 /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]