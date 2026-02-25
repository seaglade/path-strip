#!/bin/sh
# vim:sw=4:ts=4:et

set -eu

prefix=$STRIP_PATH_PREFIX
target=$STRIP_PATH_TARGET

nginxconf="
events {}
http {
    server {
        listen 80;
        location /$prefix/ {
            rewrite ^/$prefix/(.*) /\$1 break;
            proxy_pass $target/;
        }
    }
}
"

echo "$nginxconf" > /etc/nginx/nginx.conf