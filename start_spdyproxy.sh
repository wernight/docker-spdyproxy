#!/bin/sh -e

if [ -z $SPDY_USERNAME ] || [ -z $SPDY_PASSWORD ]
then
    exec spdyproxy --verbose --key /ssl/server.key --cert /ssl/server.crt
else
    exec spdyproxy --verbose --key /ssl/server.key --cert /ssl/server.crt --user $SPDY_USERNAME --pass $SPDY_PASSWORD
fi
