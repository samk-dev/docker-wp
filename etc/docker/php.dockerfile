# Install WordPress with PHP-FPM Alpine
FROM wordpress:5.7.2-php7.4-fpm-alpine

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

# Install xdebug
RUN apk --update --no-cache add autoconf g++ make && \
    pecl install -f xdebug && \
    docker-php-ext-enable xdebug && \
    apk del --purge autoconf g++ make

RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x /usr/local/bin/mhsendmail  

RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailserver:1025 --from=no-dev@mailhog.dev"' > /usr/local/etc/php/conf.d/mailhog.ini

# Append path automatically so that user doesn't have to
ADD etc/scripts/wp /usr/local/bin/wp

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp-cli && chmod +x /usr/local/bin/wp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node && Yarn
RUN apk --no-cache add nodejs yarn --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# Add nodejs and npm
RUN apk add --update npm

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /var/www/html

# Copy contents of src folder to WORKDIR
COPY app .

# Set read && write permissions
RUN chmod 777 /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]