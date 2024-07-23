#!/bin/sh
# Script to initialize and manage the MariaDB database

timeout=30
should_init_db=false

# Function to update database settings based on environment variables
update_db_settings() {
    echo "Updating database settings..."
    mysql -h localhost -u root -p'${MYSQL_ROOT_PASSWORD}' << EOF
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
    ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';

    FLUSH PRIVILEGES;
EOF
}

# Check if the database has been initialized and initialize if not
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not found, initializing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    should_init_db=true
else
    echo "Database already initialized."
fi

chown -R mysql:mysql /var/lib/mysql

# Start MariaDB
mysqld &

# Wait for MariaDB to fully start with a timeout
while ! mysqladmin ping --silent; do
    sleep 1
    timeout=$((timeout - 1))
    if [ "$timeout" -eq 0 ]; then
        echo "Failed to start MariaDB within $timeout seconds."
        exit 1
    fi
done
sleep 5

# Initialize the database if it hasn't been initialized
if [ "$should_init_db" = true ]; then
    mysql -h localhost -uroot << EOF
    SET PASSWORD FOR root@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
EOF
fi

# Update database settings
update_db_settings

mysqladmin -h localhost -u root -p'${MYSQL_ROOT_PASSWORD}' shutdown

exec mysqld
