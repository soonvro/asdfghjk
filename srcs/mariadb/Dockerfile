FROM alpine:3.19

ENV TZ=Asia/Seoul

# Set the timezone and install dumb-init
RUN set -ex \
    && apk add --no-cache \
      dumb-init \
      tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Install mariadb
RUN set -ex \
    && apk --no-cache add mariadb mariadb-client mariadb-server-utils \
    && mv /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf.orig \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld

COPY ./conf/inception.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY ./tools/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

CMD ["/usr/bin/dumb-init", "--", "/scripts/run.sh"]
