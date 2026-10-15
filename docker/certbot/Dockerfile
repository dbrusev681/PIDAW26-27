FROM python:3.14-slim

RUN pip install --no-cache-dir certbot certbot-dns-dynu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY fix-permissions.sh /usr/local/bin/fix-permissions.sh

RUN chmod +x \
    /usr/local/bin/entrypoint.sh \
    /usr/local/bin/fix-permissions.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]