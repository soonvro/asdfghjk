FROM alpine:3.19

ENV TZ=Asia/Seoul

# Set the timezone
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Install nginx
RUN set -x \
    && apk --no-cache add nginx \
    && adduser -D -g 'www' www \
    && mkdir /www \
    && chown -R www:www /var/lib/nginx \
    && chown -R www:www /www
#     && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

# COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/http.d/default.conf
COPY ./html /www

EXPOSE 80

VOLUME ["/var/log/nginx/"]

CMD ["nginx", "-g", "daemon off;"]
