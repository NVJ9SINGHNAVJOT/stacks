#!/bin/sh

# variables
DB_USER="<username>"
DB_NAME="<database_name>"
DB_PASS="<password>"

CONTAINER_NAME="<postgres_container_name>"
OUTPUT_DIR="$HOME/workspace/backups"
BACK_UP_FILE="/tmp/$CONTAINER_NAME-backup.sql"


# create output dir 
mkdir -p "$OUTPUT_DIR"

# docker exec -it <postgres_container_name> pg_dump -h <host> -U <username> -d <database_name> -F c -f /tmp/<backup_file.sql>
docker exec -it "$CONTAINER_NAME" pg_dump -U "$DB_USER" -d "$DB_NAME" -F c -f "$BACK_UP_FILE"

# docker cp <postgres_container_name>:/tmp/<backup_file.sql> /path/to/output/dir
docker cp "$CONTAINER_NAME":"$BACK_UP_FILE" "$OUTPUT_DIR"

# remove backup file from docker
docker exec "$CONTAINER_NAME" rm -rf "$BACK_UP_FILE"
