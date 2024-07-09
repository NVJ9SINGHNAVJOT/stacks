#!/bin/sh

# variables
MONGODB_URL="<your_mongodb+srv_link>"

CONTAINER_NAME="<mongodb_container_name>"
BACK_UP_DIR="$HOME/workspace/backups/$CONTAINER_NAME-backup"
DB_NAME="<database_name>"


# create dump folder in /tmp inside docker
docker exec -it "$CONTAINER_NAME" mkdir /tmp/dump

# copy backup folder from local machine to docker /tmp/dump dir
docker cp "$BACK_UP_DIR/$DB_NAME" "$CONTAINER_NAME":/tmp/dump

# docker exec -i <container_name> mongorestore --nsInclude= "<database_name>.*" /tmp/dump
docker exec -i "$CONTAINER_NAME" mongorestore --nsInclude="$DB_NAME.*" /tmp/dump

# remove folder file from docker
docker exec "$CONTAINER_NAME" rm -rf /tmp/dump
