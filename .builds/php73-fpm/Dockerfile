FROM php:7.3-fpm-alpine

ENV ENV="/etc/profile"
ENV PHPIZE_DEPS \
        autoconf \
        coreutils \
        dpkg-dev dpkg \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c

ARG MY_TZ
RUN set -eux; \
    apk upgrade --update; \
    apk add -U tzdata; \
    cp /usr/share/zoneinfo/${MY_TZ} /etc/localtime; \
    apk del tzdata; \
    rm -rf /var/cache/apk/*

COPY ./.builds/install-php-extensions /usr/local/bin/
COPY ./.builds/aliase.sh /etc/profile.d/

RUN install-php-extensions \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        imap \
        intl \
        ldap \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        sockets \
        xdebug \
        xsl \
        zip

EXPOSE 9000
CMD ["/usr/local/sbin/php-fpm"]
