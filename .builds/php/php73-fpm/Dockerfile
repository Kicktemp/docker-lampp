FROM php:7.3-fpm-alpine

COPY ./.builds/shared/aliase.sh /etc/profile.d/

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
    apk add -U tzdata shadow; \
    cp /usr/share/zoneinfo/${MY_TZ} /etc/localtime; \
    apk del tzdata; \
    rm -rf /var/cache/apk/*

COPY ./.builds/php/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        ldap \
        mysqli \
        opcache \
        pdo_mysql \
        soap \
        sockets \
        xdebug \
        xmlrpc \
        xsl \
        zip

WORKDIR "/srv/www"

COPY ./.builds/shared/httpd-php-entrypoint.sh /usr/local/bin/
COPY ./.builds/shared/create_user.sh /usr/local/bin/

EXPOSE 9000
ENTRYPOINT ["httpd-php-entrypoint.sh","php-fpm"]
#CMD ["/usr/local/sbin/php-fpm"]
