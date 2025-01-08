#!/bin/sh

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
mkdir -p /run/php
mkdir -p /var/log/php-fpm

echo "downloaded wp-cli .... waiting for config"

wp --allow-root core download
wp --allow-root core config --dbhost=mariadb:3306 --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD"
wp --allow-root core install --url="$DOMAIN_NAME" --title="$TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_MAIL"
wp --allow-root user create "$WP_USER_NAME" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS" --role="$WP_USER_ROLE"

echo "config ended..."
echo 'php-fpm starting ...'

php-fpm7.4 -R -F -y /srcs/php-fpm.conf

echo 'php-fpm failed'
