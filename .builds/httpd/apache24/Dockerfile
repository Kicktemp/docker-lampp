ARG VERSION
ARG TAG="${VERSION:-2.4}-alpine"

FROM httpd:${TAG}

COPY ./shared/aliase.sh /etc/profile.d/

ARG MY_TZ
ENV TZ=${MY_TZ} \
    ENV="/etc/profile"

RUN set -eux; \
    apk upgrade --update; \
    apk add -U tzdata shadow; \
    ln -sf /usr/share/zoneinfo/${MY_TZ} /etc/localtime; \
    rm -rf /var/cache/apk/*

COPY ./httpd/apache24/config/httpd.conf /usr/local/apache2/conf/
COPY ./shared/httpd-php-entrypoint.sh /usr/local/bin/
COPY ./shared/create_user.sh /usr/local/bin/

RUN set -eux; \
    find /usr/local/bin -type f -exec chmod +x {} \;

WORKDIR "/srv/www"

STOPSIGNAL SIGWINCH
ENTRYPOINT ["httpd-php-entrypoint.sh"]
CMD ["httpd-foreground"]
