# Version 0.0.1
FROM uwinart/base:latest

MAINTAINER Yurii Khmelevskii <y@uwinart.com>

# Install PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -yq sudo postgresql-9.4 && \
  apt-get clean && \
  sudo -u postgres mkdir /var/run/postgresql/9.4-main.pg_stat_tmp && \
  mkdir -p /data/database && chown postgres:postgres /data/database && \
  chown postgres:postgres /etc/ssl/private/ssl-cert-snakeoil.key

# set permissions to allow logins, trust the bridge, this is the default for docker YMMV
RUN echo "host    all             all             192.168.59.0/24            trust" >> /etc/postgresql/9.4/main/pg_hba.conf && \
  echo "host    all             all             172.17.0.0/16            trust" >> /etc/postgresql/9.4/main/pg_hba.conf && \
  echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

ADD run.sh /run.sh

USER postgres

VOLUME ["/data/database", "/var/log/postgresql", "/var/lib/postgresql/9.4/main"]

EXPOSE 5432

CMD ["/run.sh"]
