#!/usr/bin/env bash

# check to see where the script is being run from and set local variables
if [ -f .env ]; then
  echo "INFO: running from top level of repository"
  source .env
  LE_DIR=$(pwd)
else  
  echo "ERROR: Could not find the .env file?"
  exit 1;  
fi

# FQDN_OR_IP should not include prefix of www.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 FQDN_OR_IP" >&2
    exit 1;
else
    FQDN_OR_IP=$1
fi

if [ ! -d "etc/certs/live/${FQDN_OR_IP}" ]; then
    echo "INFO: making certs directory"
    mkdir -p .config/certs/live/${FQDN_OR_IP}
fi

# generate and add keys
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem \
    -days 365 -nodes -subj '//CN='${FQDN_OR_IP}''

echo "All good.. Certificates generated sucessfully ✅"

mv cert.pem .config/certs/live/${FQDN_OR_IP}/fullchain.pem
mv key.pem .config/certs/live/${FQDN_OR_IP}/privkey.pem
exit 0;