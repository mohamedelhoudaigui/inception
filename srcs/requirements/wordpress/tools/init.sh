#!/bin/bash

# Wait for MariaDB to be ready
until mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASSWORD}" -e "SHOW DATABASES;" > /dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 3
done

wp core download --allow-root

wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${DB_HOST}" \
    --allow-root

wp core install \
    --url="${DOMAIN_NAME}" \
    --title="${TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

wp user create "${WP_USER_NAME}" "${WP_USER_EMAIL}" \
    --role="${WP_USER_ROLE}" \
    --user_pass="${WP_USER_PASS}" \
    --allow-root

wp theme install twentytwentyfour --allow-root
wp theme activate twentytwentyfour --allow-root

echo "Starting PHP-FPM..."

exec php-fpm7.4 --nodaemonize