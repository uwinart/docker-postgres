# Version 0.0.1
FROM uwinart/base:latest

MAINTAINER Yurii Khmelevskii <y@uwinart.com>

# Install PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -yq sudo postgresql-9.6 && \
  apt-get clean && \
  sudo -u postgres mkdir /var/run/postgresql/9.6-main.pg_stat_tmp && \
  mkdir -p /data/database && chown postgres:postgres /data/database

# set permissions to allow logins, trust the bridge, this is the default for docker YMMV
RUN echo "host    all             all             192.168.59.0/24            trust" >> /etc/postgresql/9.6/main/pg_hba.conf && \
  echo "host    all             all             172.17.0.0/16            trust" >> /etc/postgresql/9.6/main/pg_hba.conf && \
  echo "listen_addresses='*'" >> /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/shared_buffers\s*=.*/shared_buffers = 1024MB/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#effective_cache_size\s*=.*/effective_cache_size = 2048MB/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#maintenance_work_mem\s*=.*/maintenance_work_mem = 256MB/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#work_mem\s*=.*/work_mem = 2MB/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/max_connections\s*=.*/max_connections = 1000/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#autovacuum\s*=.*/autovacuum = on/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#autovacuum_naptime\s*=.*/autovacuum_naptime = 30min/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#autovacuum_vacuum_threshold\s*=.*/autovacuum_vacuum_threshold = 500/g" /etc/postgresql/9.6/main/postgresql.conf && \
  sed -i -e "s/#autovacuum_analyze_threshold\s*=.*/autovacuum_analyze_threshold = 250/g" /etc/postgresql/9.6/main/postgresql.conf
  # sed -i -e "s/ssl_key_file\s*=.*/ssl_key_file = '\/etc\/ssl\/ssl-cert-snakeoil\.key'/g" /etc/postgresql/9.6/main/postgresql.conf && \
  # mv /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/ssl-cert-snakeoil.key && \
  # chown postgres /etc/ssl/ssl-cert-snakeoil.key

ADD run.sh /run.sh

USER postgres

VOLUME ["/data/database", "/var/log/postgresql", "/var/lib/postgresql/9.6/main"]

EXPOSE 5432

CMD ["/run.sh"]
