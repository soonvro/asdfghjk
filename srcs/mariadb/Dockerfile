FROM alpine:3.19

# Set the timezone
ENV TZ=Asia/Seoul

RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

RUN apk --no-cache add mariadb mariadb-client mariadb-server-utils \
    && addgroup mysql mysql \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld

COPY ./conf/inception.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

# CMD ["/bin/sh"]

ENTRYPOINT ["/scripts/run.sh"]

CMD ["mysqld_safe", "--datadir='/var/lib/mysql'"]
