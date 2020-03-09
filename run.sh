#!/bin/bash
mkdir -p /etc/shadowsocks-libev/
docker run -d -p 8443:443 -p 8443:443/udp -v /etc/shadowsocks-libev:/etc/shadowsocks-libev --restart=always --name ss-libev xzl2021/shadowsocks_libev-obfs-nginx:latest
