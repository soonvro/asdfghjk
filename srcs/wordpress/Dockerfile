FROM alpine:3.19

# Set the timezone
ENV TZ=Asia/Seoul

RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

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
      php82-mysqli

# PHP Global Configuration
RUN sed -i -r 's|.*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=1|g' /etc/php*/php.ini \
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
RUN mkdir -p /var/run/php-fpm82/ \
#     && chown lighttpd:root /var/run/php-fpm82 \
    && sed -i -r 's|^.*listen =.*|listen = /run/php-fpm82/php82-fpm.sock|g' /etc/php*/php-fpm.d/www.conf \
    && sed -i -r 's|^pid =.*|pid = /run/php-fpm82/php82-fpm.pid|g' /etc/php*/php-fpm.conf \
    && sed -i -r 's|^.*listen.mode =.*|listen.mode = 0640|g' /etc/php*/php-fpm.d/www.conf

# Install wordpress
RUN set -ex \
    && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && php wp-cli.phar --info \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp core download --locale=ko_KR --allow-root

COPY ./tools/run.sh /scripts/run.sh

ENTRYPOINT ["/scripts/run.sh"]

CMD ["php82-fpm", "-F"]
