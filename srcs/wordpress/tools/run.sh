#!/bin/sh

timeout=30

# Wait for MariaDB to fully start with a timeout
echo "Waiting for MariaDB to fully start..."
while ! mysqladmin -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD ping --silent; do
    sleep 1
    timeout=$((timeout - 1))
    if [ "$timeout" -eq 0 ]; then
        echo "Failed to start MariaDB within $timeout seconds."
        exit 1
    fi
done
sleep 15

if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    wp config create \
      --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST \
      --path=/var/www/html/wordpress --allow-root <<PHP
    define( 'WP_CACHE', true );
PHP
    wp core install \
      --url=$WP_URL --title="$WP_TITLE" \
      --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL \
      --path=/var/www/html/wordpress --allow-root
    wp user create \
      $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author \
      --path=/var/www/html/wordpress --allow-root
    echo "WordPress installation and configuration completed."
else
    echo "WordPress is already installed."
fi

echo "Starting PHP-FPM..."
exec php-fpm82 -F
