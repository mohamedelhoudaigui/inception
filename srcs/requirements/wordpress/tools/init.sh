#!/bin/sh

echo 'moved the config'
mv /srcs/wp-config.php /var/www/html/wp-config.php

sleep 10

wp --allow-root config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${DB_HOST}

echo 'php-fpm starting ...'

php-fpm7.4 -R -F -y /srcs/php-fpm.conf

echo 'php-fpm failed'

