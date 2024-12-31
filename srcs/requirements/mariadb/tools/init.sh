#!/bin/sh

mysqld_safe &

sleep 3

echo 'staring mariadb 1...'

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

echo 'staring mariadb 2...'

exec mysqld_safe