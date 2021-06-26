# Install WordPress with PHP-FPM Alpine
FROM wordpress:5.7.2-php7.4-fpm-alpine

# Install soap and xml extensions
RUN set -ex && apk --no-cache add \
    libxml2-dev \
    php7-simplexml \
    php7-xml
RUN docker-php-ext-install soap

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
COPY server .

# Set read && write permissions
RUN chmod 777 /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]