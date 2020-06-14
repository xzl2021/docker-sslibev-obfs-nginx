#!/bin/bash
mkdir -p /etc/shadowsocks-libev-obfs/
docker run -d -p 8443:443 -p 8443:443/udp -v /etc/shadowsocks-libev-obfs:/etc/shadowsocks-libev --restart=always --name ss-obfs sslibev-obfs-nginx:latest
