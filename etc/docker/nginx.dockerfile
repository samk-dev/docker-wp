# Install Linux Alpine with Ngnix
FROM nginx:1.21-alpine

# Install vim && nano
RUN apk update \
    && apk add less vim nano

# Set working dir to /etc/ngnix
WORKDIR /etc/nginx/conf.d

# Copy Ngnix configuration to the container
COPY etc/config/nginx.conf .

# Rename Ngnix config file
RUN mv nginx.conf default.conf

# Change working dir to html dir
WORKDIR /var/www/html

# Copy all files to working dir
COPY app .