#!/bin/sh

create_user.sh ${APP_USER_ID:-1000} ${APP_GROUP_ID:-1000}

exec "$@"