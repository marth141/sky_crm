#!/bin/bash
# Docker entrypoint script

DB_USER=${DATABASE_USER:-postgres}

while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DB_USER
do
    echo "$(date) - waiting for database to start"
    sleep 2
done

bin="/app/bin/sky_crm"
eval "$bin eval \"Web.Release.migrate\""

exec "$bin" "start"