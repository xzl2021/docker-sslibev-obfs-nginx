#
# Dockerfile for shadowsocks-libev
#

FROM alpine:latest
LABEL maintainer="kev <noreply@datageek.info>, Sah <contact@leesah.name>, xzl2021 <xzl2021#hotmail.com>"

WORKDIR /
RUN set -ex \
      # Build environment setup
      && apk add --no-cache --virtual .build-deps \
           autoconf \
           automake \
           build-base \
           c-ares-dev \
           libcap \
           libev-dev \
           libtool \
           libsodium-dev \
           linux-headers \
           mbedtls-dev \
           pcre-dev \
           git \
      # Build & install
      && git clone --depth=1 https://github.com/shadowsocks/shadowsocks-libev.git /tmp/libev \
      && cd /tmp/libev \
      && git submodule update --init --recursive \
      && ./autogen.sh \
      && ./configure --prefix=/usr --disable-documentation \
      && make install \
      && ls /usr/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
      && apk del .build-deps \
      # Runtime dependencies setup
      && apk add --no-cache \
           tzdata \
           nginx \
           ca-certificates \
           rng-tools \
           $(scanelf --needed --nobanner /usr/bin/ss-* \
           | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
           | sort -u) \
      && mkdir -p /files \
      && wget --no-check-certificate -O /files/config.json https://raw.githubusercontent.com/xzl2021/docker-sslibev-obfs-nginx/master/files/config.json \
      && wget --no-check-certificate -O /usr/local/bin/ss-libev https://raw.githubusercontent.com/xzl2021/docker-sslibev-obfs-nginx/master/files/start.sh \
      && wget --no-check-certificate -O /etc/nginx/conf.d/obfs.conf https://raw.githubusercontent.com/xzl2021/docker-sslibev-obfs-nginx/master/files/obfs_nginx.conf \
      && wget --no-check-certificate -O /usr/local/bin/obfs-server https://raw.githubusercontent.com/xzl2021/docker-sslibev-obfs-nginx/master/files/obfs-server \
      && chmod +x /usr/local/bin/obfs-server /usr/local/bin/ss-libev \
      && cd / \
      && rm -rf /tmp/*

VOLUME /etc/shadowsocks-libev
ENV TZ=Asia/Shanghai

CMD ["ss-libev"]
