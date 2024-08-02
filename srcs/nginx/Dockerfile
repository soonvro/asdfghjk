FROM alpine:3.19

ENV TZ=Asia/Seoul

# Set the timezone
RUN set -ex \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Install nginx
RUN set -ex \
    && apk add --no-cache nginx \
    && adduser -D -g 'www' www \
    && chown -R www:www /var/lib/nginx \
    && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

# Generate SSL certificate
RUN set -ex \
    && apk add --no-cache openssl \
    && mkdir -p /etc/ssl/certs/ /etc/ssl/private/ \
    && openssl req \
      -newkey rsa:2048 -nodes -keyout /etc/ssl/private/nginx-selfsigned.key \
      -x509 -days 365 -out /etc/ssl/certs/nginx-selfsigned.crt \
      -subj "/C=KR/ST=Seoul/L=Seoul/O=42/OU=42 Seoul/CN=sokwon.42.fr" \
    && chown -R www:www /etc/ssl/certs/ /etc/ssl/private/

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/inception.conf /etc/nginx/http.d/inception.conf

EXPOSE 443

VOLUME ["/var/log/nginx/"]

CMD ["nginx"]
