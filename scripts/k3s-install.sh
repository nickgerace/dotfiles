#!/usr/bin/env bash
if [ ! "$(command -v kubectl)" ] || [ ! "$(command -v docker)" ] || [ ! "$(command -v helm)" ]; then
    printf "[INFO] Recommended dependencies: kubectl docker helm\n"
    exit 1
fi

if [ $K3S_VERSION ]; then
    TEMP_K3S_VERSION="v${K3S_VERSION}+k3s2"
    printf "[INFO] Running with version: ${TEMP_K3S_VERSION}\n"
    printf "[INFO] If the image does not exist, use a valid image: https://hub.docker.com/r/rancher/k3s/tags\n"
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${TEMP_K3S_VERSION} sh -
else
    curl -sfL https://get.k3s.io | sh -
fi

if [ $COPY_CONFIG ] && [ $COPY_CONFIG == "true" ]; then
    cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
    printf "[INFO] Config file location: ${HOME}/.kube/config\n"
else
    printf "[INFO] Config file location: /etc/rancher/k3s/k3s.yaml\n"
fi
