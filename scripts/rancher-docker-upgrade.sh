#!/usr/bin/env bash
set -e

if [ ! $1 ] || [ ! $2 ]; then
    echo "-----------------------------------------------------------------------------------------------------------"
    echo "required arguments  |  <rancher-container-name>  <new-tag>         <optional-new-image-name>"
    echo "descriptions        |  Docker container ID       Docker image tag  image name (defaults to rancher/rancher)"
    echo "example #1          |  f7ae457bd1ff              v2.6.2            nickgerace/rancher"
    echo "example #2          |  f576fbbd7b15              latest"
    echo "-----------------------------------------------------------------------------------------------------------"
    exit 1
fi

IMAGE_NAME=rancher/rancher
if [ $3 ] && [ "$3" != "" ]; then
    IMAGE_NAME=$3
fi

OLD_IMAGE=$(docker container inspect $1 | jq ".[0].Config.Image" | tr -d '"')
docker stop $1
docker create --volumes-from $1 --name rancher-data $OLD_IMAGE
docker run -d --privileged \
    --volumes-from rancher-data
    --restart=unless-stopped -p 80:80 -p 443:443 \
    --no-cacerts
    $IMAGE_NAME:$2
