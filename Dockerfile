FROM debian:bookworm-slim

COPY config/ /etc/mysql/
COPY --chmod=755 ./init.sql /docker-entrypoint-initdb.d/
COPY --chmod=755 ./docker-entrypoint.sh /usr/local/bin/
COPY --chmod=755 ./healthcheck.sh /usr/local/bin/healthcheck.sh

LABEL authors="Ethan Besson" \
    maintainer="Ethan Besson <contact@southlabs.fr>" \
    title="Simple MariaDB Database" \
    description="MariaDB Database for relational SQL" \
    documentation="https://hub.docker.com/_/mariadb/" \
    base.name="docker.io/library/debian:bookworm-slim" \
    licenses="AFL-3.0" \
    source="https://github.com/InstaZDLL/simple-mysql-docker" \
    vendor="MariaDB Community" \
    version="1.0.0" \
    url="https://github.com/InstaZDLL/simple-mysql-docker"

RUN apt-get update && \
    apt-get install -y mariadb-server openssl wget gosu && \
    gosu nobody true && \ 
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /docker-entrypoint-initdb.d/ && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 1777 /var/run/mysqld /var/lib/mysql && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql  && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal

VOLUME [/var/lib/mysql]

EXPOSE 3306

HEALTHCHECK --start-period=5m \
    CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]