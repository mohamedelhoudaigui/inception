#!/bin/sh

sleep 10

sed -i "s/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/" /etc/php/7.4/fpm/pool.d/www.conf

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
mkdir -p /run/php
mkdir -p /var/log/php-fpm

echo "downloaded wp-cli .... waiting for config"

wp --allow-root core download
wp --allow-root core config --dbhost=mariadb:3306 --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD"
wp --allow-root core install --url="$DOMAIN_NAME" --title="$TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL"
wp --allow-root user create "$WP_USER_NAME" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS" --role="$WP_USER_ROLE"
# wp --allow-root theme install twentysixteen
# wp --allow-root theme activate twentytwentyfour

echo "config ended..."
echo 'php-fpm starting ...'

php-fpm7.4 -F

echo 'php-fpm failed'
