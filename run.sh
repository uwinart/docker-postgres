#!/bin/bash
set -e

POSTGRESQL_BIN=/usr/lib/postgresql/9.4/bin/postgres
POSTGRESQL_CONFIG_FILE=/etc/postgresql/9.4/main/postgresql.conf
POSTGRESQL_DATA=/var/lib/postgresql/9.4/main

exec $POSTGRESQL_BIN -D $POSTGRESQL_DATA -c config_file=$POSTGRESQL_CONFIG_FILE
