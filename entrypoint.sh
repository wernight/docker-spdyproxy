#!/bin/sh -e

if [ ! -s /ssl/tls.key ]
then
    ip=$(curl -L http://ipinfo.io/ip)
    echo "Generating self-signed certificate for IP: $ip"
    openssl req -new -days 3650 -x509 -nodes -subj "/O=spdyproxy/CN=$ip" -out /ssl/tls.crt -keyout /ssl/tls.key
    chmod 600 /ssl/tls.key
fi

if [ -z "$*" ]
then
    if [ -z $SPDY_USERNAME ] || [ -z $SPDY_PASSWORD ]
    then
        exec spdyproxy --verbose --key /ssl/tls.key --cert /ssl/tls.crt
    else
        exec spdyproxy --verbose --key /ssl/tls.key --cert /ssl/tls.crt --user $SPDY_USERNAME --pass $SPDY_PASSWORD
    fi
else
    exec spdyproxy "$@"
fi
