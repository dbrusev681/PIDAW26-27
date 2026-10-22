#!/bin/bash

set -u

if [ ! -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ]; then
    echo "No certificate found for ${DOMAIN}; requesting one..."

    certbot certonly \
    --authenticator dns-dynu \
    --dns-dynu-credentials /root/dynu-credentials.ini \
    --email "${EMAIL}" \
    --agree-tos \
    --no-eff-email \
    --preferred-challenges dns \
    -d "${DOMAIN}" \
    -d "${ALTDOMAIN}" \
    --deploy-hook /usr/local/bin/fix-permissions.sh
fi

while true; do
    echo "Checking whether certificates need renewal..."
    certbot renew --deploy-hook /usr/local/bin/fix-permissions.sh
    echo "Next renewal check in 12 hours."
    sleep 43200
    clear
done
