FROM httpd:2.4-alpine

ENV ENV="/etc/profile"

ARG MY_TZ
RUN set -eux; \
    apk upgrade --update; \
    apk add -U tzdata; \
    cp /usr/share/zoneinfo/${MY_TZ} /etc/localtime; \
    apk del tzdata; \
    rm -rf /var/cache/apk/*

RUN set -eux; \
    [ ! -d /var/www/html ]; \
    mkdir -p /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 777 /var/www/html;

COPY ./.builds/apache24/config/httpd.conf /usr/local/apache2/conf/
COPY ./.builds/aliase.sh /etc/profile.d/

STOPSIGNAL SIGWINCH
CMD ["httpd-foreground"]
