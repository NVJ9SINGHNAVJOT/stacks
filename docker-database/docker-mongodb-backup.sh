#!/bin/sh

# variables
MONGODB_URL="<your_mongodb+srv_link>"

CONTAINER_NAME="<mongodb_container_name>"
OUTPUT_DIR="$HOME/workspace/backups"
BACK_UP_FOLDER="/tmp/$CONTAINER_NAME-backup"


# create output dir 
mkdir -p "$OUTPUT_DIR"

# make custom_backup dir in docker
docker exec -it "$CONTAINER_NAME" mkdir "$BACK_UP_FOLDER"
# docker exec -i <mongodb_container_name> /usr/bin/mongodump --uri "<your_mongodb+srv_link>" --out ~/tmp/<my_custom_backup>
docker exec -i "$CONTAINER_NAME" /usr/bin/mongodump --uri "$MONGODB_URL" --out "$BACK_UP_FOLDER"

# docker cp <mongodb_container_name>:/tmp/<my_custom_backup> /path/to/output/dir
docker cp "$CONTAINER_NAME":"$BACK_UP_FOLDER" "$OUTPUT_DIR"

# remove backup file from docker
docker exec "$CONTAINER_NAME" rm -rf "$BACK_UP_FOLDER"