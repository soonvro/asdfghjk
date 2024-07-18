FROM alpine:3.19

ENV TZ=Asia/Seoul
ENV HOME=/root

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
    && addgroup mysql mysql \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld

# RUN sed -i "s|^skip-networking|#skip-networking|" /etc/my.cnf.d/mariadb-server.cnf &&\
# 	sed -i "s|^#bind-address|bind-address|" /etc/my.cnf.d/mariadb-server.cnf
COPY ./conf/inception.cnf $HOME/.my.cnf
COPY ./tools/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

CMD ["/usr/bin/dumb-init", "--", "/scripts/run.sh"]
