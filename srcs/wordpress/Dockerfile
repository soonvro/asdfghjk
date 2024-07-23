FROM alpine:3.19

ENV TZ=Asia/Seoul

# Set the timezone
RUN set -ex \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Install required packages
RUN set -ex \
    && apk add --no-cache \
      # Alpine packages for "imagemagick" contains ~120 .so files, see: https://github.com/docker-library/wordpress/pull/497
      imagemagick \
      php82 php82-cgi php82-fpm php82-bcmath php82-bz2 php82-ctype \
      php82-curl php82-dom php82-enchant php82-exif php82-gd php82-gettext \
      php82-gmp php82-iconv php82-imap php82-intl php82-json php82-mbstring \
      php82-opcache php82-openssl php82-phar php82-posix php82-pspell \
      php82-session php82-simplexml php82-sockets php82-sysvmsg \
      php82-sysvsem php82-sysvshm php82-tidy php82-xml php82-xmlreader \
      php82-xmlwriter php82-xsl php82-zip \
      # for access mariadb
      mariadb-client \
      php82-mysqli \
      # for signal handling
      dumb-init


# PHP Global Configuration
RUN sed -i -r 's|.*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=0|g' /etc/php*/php.ini \
    && sed -i -r 's#.*safe_mode =.*#safe_mode = Off#g' /etc/php*/php.ini \
    && sed -i -r 's#.*expose_php =.*#expose_php = Off#g' /etc/php*/php.ini \
    && sed -i -r 's#memory_limit =.*#memory_limit = 536M#g' /etc/php*/php.ini \
    && sed -i -r 's#upload_max_filesize =.*#upload_max_filesize = 128M#g' /etc/php*/php.ini \
    && sed -i -r 's#post_max_size =.*#post_max_size = 256M#g' /etc/php*/php.ini \
    && sed -i -r 's#^file_uploads =.*#file_uploads = On#g' /etc/php*/php.ini \
    && sed -i -r 's#^max_file_uploads =.*#max_file_uploads = 12#g' /etc/php*/php.ini \
    && sed -i -r 's#^allow_url_fopen = .*#allow_url_fopen = On#g' /etc/php*/php.ini \
    && sed -i -r 's#^.default_charset =.*#default_charset = "UTF-8"#g' /etc/php*/php.ini \
    && sed -i -r 's#^.max_execution_time =.*#max_execution_time = 150#g' /etc/php*/php.ini \
    && sed -i -r 's#^max_input_time =.*#max_input_time = 90#g' /etc/php*/php.ini

# PHP-FPM Configuration
RUN set -ex \
    && adduser -D -H -u 82 -S 'www-data' www-data \
    && mkdir -p /var/run/php-fpm82 \
    && chown -R www-data:www-data /var/run/php-fpm82 \
    && sed -i 's/.*user = nobody.*/user = www-data/' /etc/php*/php-fpm.d/www.conf \
    && sed -i 's/.*group = nobody.*/group = www-data/' /etc/php*/php-fpm.d/www.conf \
    && sed -i 's/^.*listen =.*/listen = 9000/g' /etc/php*/php-fpm.d/www.conf

# Install wordpress
RUN set -ex \
    && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && php wp-cli.phar --info \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp-cli.phar \
    && ln -s /usr/local/bin/wp-cli.phar /usr/local/bin/wp \
    && mkdir -p /var/www/html/wordpress \
    && wp core download --allow-root --path=/var/www/html/wordpress

COPY ./tools/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh

EXPOSE 9000

CMD ["/usr/bin/dumb-init", "--", "/scripts/run.sh"]
