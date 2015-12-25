#!/bin/sh -e

if [ ! -s /ssl/server.key ]
then
    ip=$(curl -L http://ipinfo.io/ip)
    echo "Generating self-signed certificate for IP: $ip"
    openssl req -new -days 3650 -x509 -nodes -subj "/O=spdyproxy/CN=$ip" -out /ssl/server.crt -keyout /ssl/server.key
    chmod 600 /ssl/server.key
fi

exec "$@"
