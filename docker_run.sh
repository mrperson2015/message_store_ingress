#!/usr/bin/env bash

CONTAINER_NAME="msg_store-data_api"
IMAGE="cam/message_store_ingress"

docker pull $IMAGE:latest

for container in `docker ps -a --format "{{.Names}}"`;
do
    if [ $container == $CONTAINER_NAME ];
    then
        echo "Stopping and Removing container [$CONTAINER_NAME]"
        docker rm --force "$CONTAINER_NAME"
    fi
done

docker run \
    -it \
    -p 3000:3000 \
    -e MESSAGE_STORE_USER='message_store' \
    -e MESSAGE_STORE_HOST='messagestore' \
    -e MESSAGE_STORE_DATABASE='message_store' \
    -e MESSAGE_STORE_PASSWORD='' \
    -e MESSAGE_STORE_PORT=5432 \
    --name $CONTAINER_NAME \
    --link messagestore \
    $IMAGE:latest