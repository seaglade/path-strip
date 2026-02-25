#!/bin/sh
# vim:sw=4:ts=4:et

set -eu

nginxconf="
events {}
http {
    server {
        listen 80;
        location /$STRIP_PATH_PREFIX/ {
            ^/$STRIP_PATH_PREFIX/(.*) /$1 break;
            proxy_pass $STRIP_PATH_TARGET/;
        }
    }
}
"

echo "$nginxconf" > /etc/nginx/nginx.conf