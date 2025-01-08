#!/bin/sh

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
mkdir -p /run/php
mkdir -p /var/log/php-fpm

wp --allow-root core download

echo "downloaded wp-cli .... waiting for config"

echo 'php-fpm starting ...'

php-fpm7.4 -R -F -y /srcs/php-fpm.conf

echo 'php-fpm failed'
