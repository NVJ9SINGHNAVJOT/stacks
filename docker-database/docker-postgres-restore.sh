#!/bin/sh

# variables
DB_USER="<username>"
DB_NAME="<database_name>"

CONTAINER_NAME="<postgres_container_name>"
BACK_UP_DIR="$HOME/workspace/backups/$CONTAINER_NAME-backup.sql"


# docker exec -i <postgres_container_name> pg_restore -U <username> -v -d <database_name> < /path/to/backup-file.sql
docker exec -i "$CONTAINER_NAME" pg_restore -U "$DB_USER" -v -d "$DB_NAME" < "$BACK_UP_DIR"
