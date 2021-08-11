#!/usr/bin/env bash
if [ ! $1 ] || [ ! $2 ] || [ ! $3 ]; then
    echo "required arguments: <version> <hostname> <rancher-tag>"
    echo "example: 2.6.0 my.hostname.dev v2.6-head"
    exit 1
fi
helm upgrade rancher rancher-latest/rancher -n cattle-system \
    --version $1 \
    --set hostname=$2 \
    --set rancherImageTag=$3
