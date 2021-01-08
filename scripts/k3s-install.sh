#!/usr/bin/env bash
if [ ! "$(command -v kubectl)" ] || [ ! "$(command -v docker)" ] || [ ! "$(command -v helm)" ]; then
    printf "[k3s-install] Recommended dependencies: kubectl docker helm\n"
    exit 1
fi

if [ $1 ]; then
    TEMP="v${1}+k3s2"
    printf "[k3s-install] Running with version: ${TEMP}\n"
    printf "[k3s-install] If the image does not exist, use a valid image: https://hub.docker.com/r/rancher/k3s/tags\n"
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${TEMP} sh -
else
    curl -sfL https://get.k3s.io | sh -
fi

printf "[k3s-install] Config file location: /etc/rancher/k3s/k3s.yaml\n"
