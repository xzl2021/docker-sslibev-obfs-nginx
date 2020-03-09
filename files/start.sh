#!/bin/sh
if [ ! -f /etc/shadowsocks-libev/config.json ]; then
	cp /files/config.json /etc/shadowsocks-libev/config.json
fi

/usr/bin/ss-server -v -c /etc/shadowsocks-libev/config.json -f /var/run/shadowsocks-libev.pid
mkdir -p /run/nginx
nginx -g 'daemon off;'