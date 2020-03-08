#!/bin/bash
mkdir -p /etc/shadowsocks-libev/
docker run -d -p 8443:443 -v /etc/shadowsocks-libev:/etc/shadowsocks-libev --name ss-libev xzl2021/shadowsocks_libev-obfs-nginx:latest
