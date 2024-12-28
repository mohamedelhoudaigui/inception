#!/bin/sh
set -e 

mysqld_safe &

until mysql -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done

# Check if database exists
DB_EXISTS=$(mysql -e "SHOW DATABASES LIKE 'wordpressdb';" | grep wordpressdb)

if [ -z "$DB_EXISTS" ]; then
    mysql << EOF
    CREATE DATABASE wordpressdb;
    CREATE USER 'wordpress'@'%' IDENTIFIED BY 'wordpress';
    GRANT ALL PRIVILEGES ON wordpressdb.* TO 'wordpress'@'%';
    FLUSH PRIVILEGES;
EOF
fi

mysqladmin shutdown

exec mysqld_safe