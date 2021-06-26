#!/usr/bin/env bash

# check to see where the script is being run from and set local variables
if [ -f .env ]; then
  echo "INFO: running from top level of repository"
  source .env
  LE_DIR=$(pwd)/etc/scripts
else
  if [ ! -f ../../.env ]; then
    echo "ERROR: Could not find the .env file?"
    exit 1;
  fi
  echo "INFO: running from the letsencrypt directory"
  source ../../.env
  LE_DIR=$(pwd)
  cd ../
fi
REPO_DIR=$(dirname ${LE_DIR})

# get full directory path
if [ $(dirname ${SSL_CERTS_DIR}) = '.' ]; then
  CERTS=$REPO_DIR${SSL_CERTS_DIR:1}
else
  CERTS=${SSL_CERTS_DIR}
fi
if [ $(dirname ${SSL_CERTS_DATA_DIR}) = '.' ]; then
  CERTS_DATA=$REPO_DIR${SSL_CERTS_DATA_DIR:1}
else
  CERTS_DATA=${SSL_CERTS_DATA_DIR}
fi

# FQDN_OR_IP should not include prefix of www.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 FQDN_OR_IP" >&2
    exit 1;
else
    FQDN_OR_IP=$1
fi

if [ ! -d "${CERTS}/live/${FQDN_OR_IP}" ]; then
    echo "INFO: making certs directory"
    mkdir -p ${CERTS}/live/${FQDN_OR_IP}
fi

# generate and add keys
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem \
    -days 365 -nodes -subj '/CN='${FQDN_OR_IP}''

echo "All good.. Certificates generated sucessfully ✅"

exit 0;