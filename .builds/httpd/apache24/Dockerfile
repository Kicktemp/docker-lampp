FROM httpd:2.4-alpine

COPY ./.builds/shared/aliase.sh /etc/profile.d/

ENV ENV="/etc/profile"

ARG MY_TZ
RUN set -eux; \
    apk upgrade --update; \
    apk add -U tzdata shadow; \
    cp /usr/share/zoneinfo/${MY_TZ} /etc/localtime; \
    apk del tzdata; \
    rm -rf /var/cache/apk/*

WORKDIR "/srv/www"

COPY ./.builds/httpd/apache24/config/httpd.conf /usr/local/apache2/conf/
COPY ./.builds/shared/httpd-php-entrypoint.sh /usr/local/bin/
COPY ./.builds/shared/create_user.sh /usr/local/bin/

STOPSIGNAL SIGWINCH
ENTRYPOINT ["httpd-php-entrypoint.sh"]
CMD ["httpd-foreground"]
