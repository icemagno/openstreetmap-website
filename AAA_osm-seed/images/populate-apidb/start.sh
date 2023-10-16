#!/usr/bin/env bash

set -e
export PGPASSWORD=$POSTGRES_PASSWORD

mkdir -p /mnt/data
cd /mnt/data

# Get the data
echo "Downloading $pbfFile ..."
wget $URL_FILE_TO_IMPORT
file=$(basename $URL_FILE_TO_IMPORT)
echo "Downloaded File"

function initializeDatabase() {
  cockroach sql --insecure \
  --host $POSTGRES_HOST \
  --execute "CREATE DATABASE IF NOT EXISTS $POSTGRES_DB"

  cockroach sql --insecure \
  --host $POSTGRES_HOST \
  --execute "SET CLUSTER SETTING sql.conn.max_read_buffer_message_size = '64MiB'"
}

function importData () {
  pbfFile=$file
  echo "Importing $pbfFile ..."
  osm2pgsql \
  -c $pbfFile \
  -H $POSTGRES_HOST \
  -P $POSTGRES_PORT \
  -d $POSTGRES_DB \
  -U $POSTGRES_USER
}

flag=true
while "$flag" = true; do
    # sleep 360000
    # curl "http://$POSTGRES_HOST:5432/health?ready=1" || continue
    # Change flag to false to stop ping the DB
    flag=false
    initializeDatabase
    importData
done
