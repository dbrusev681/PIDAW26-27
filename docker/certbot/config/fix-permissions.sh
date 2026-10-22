#!/bin/sh

set -eu

DOMAIN="${DOMAIN:?DOMAIN is required}"
GRUPO="${GRUPO:?GRUPO is required}"

chown root:"${GRUPO}" /etc/letsencrypt/live /etc/letsencrypt/archive

chmod 710 /etc/letsencrypt/live /etc/letsencrypt/archive
chown root:"${GRUPO}" /etc/letsencrypt/archive/"${DOMAIN}"/privkey*.pem
chmod 640 /etc/letsencrypt/archive/"${DOMAIN}"/privkey*.pem
