#!/bin/sh
set -e #if any command exited with a non zero value the script will exit

mysqld_safe &

until mysql -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done

# Check if database exists
DB_EXISTS=$(mysql -e "SHOW DATABASES LIKE '${DB_NAME}';" | grep ${DB_NAME})

if [ -z "$DB_EXISTS" ]; then
    mysql << EOF
    CREATE DATABASE ${DB_NAME};
    CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOF
fi

mysqladmin shutdown

exec mysqld_safe