#!/bin/sh

# Set user defined timezone
ln -sf /usr/share/zoneinfo/${TZ:-UTC} /etc/localtime

# Create host userid/groupid for the apache and fpm processes user
create_user.sh ${APP_USER_ID:-1000} ${APP_GROUP_ID:-1000}

#PHP_INI_DIR=/usr/local/etc/php
#mkdir -p ${PHP_INI_DIR}

# Add host.docker.internal to /etc/hosts
#echo -e "$(ip route | awk '/default/ { print $3 }')\thost.docker.internal" >> /etc/hosts

# PHP configuration
if [ -d "${PHP_INI_DIR}" ]; then

  # Activate development/production php.ini
  cp ${PHP_INI_DIR}/php.ini-${PHP_ENV:-production} ${PHP_INI_DIR}/php.ini

  echo "date.timezone=${TZ:-UTC}" > ${PHP_INI_DIR}/conf.d/user-date-time.ini
  echo "xdebug.remote_host=${XDEBUG_REMOTE_HOST:-$(ip route | awk '/default/ { print $3 }')}" > ${PHP_INI_DIR}/conf.d/user-xdebug-remote-host.ini

  #echo "xdebug.remote_host=host.docker.internal" > ${PHP_INI_DIR}/conf.d/user-xdebug-remote-host.ini
fi

exec "$@"