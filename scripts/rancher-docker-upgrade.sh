#!/usr/bin/env bash
set -e
if [ ! $1 ] || [ ! $2 ]; then    
    echo "required argument: <rancher-container-name> <new-tag> <optional-volume-name>"    
    exit 1
fi    
local VOLUME_NAME=rancher-data    
if [ $3 ] && [ "$3" != "" ]; then    
    VOLUME_NAME=$3    
fi    
local OLD_TAG=$(docker container inspect $1 | jq ".[0].Config.Image" | tr -d '"' | cut -d ":" -f2)    
docker stop $1                                                                  
docker create --volumes-from $1 --name rancher-data rancher/rancher:$OLD_TAG                                              
docker run -d --privileged --volumes-from $VOLUME_NAME --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:$2
