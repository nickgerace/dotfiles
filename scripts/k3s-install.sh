#!/usr/bin/env bash

set -e
if [ ! "$(command -v kubectl)" ] || [ ! "$(command -v docker)" ] || [ ! "$(command -v helm)" ]; then
    printf "[INFO] Recommended dependencies: kubectl docker helm\n"
    exit 1
fi

printf "[INFO] If inputting a release version, use a valid tag: https://github.com/k3s-io/k3s/releases\n"
read -p "[INFO] Input a release version (leave blank to use latest stable): " TEMP_VERSION
if [ $TEMP_VERSION ]; then
    printf "[INFO] Running with version: $TEMP_VERSION\n"
    sudo curl -sfL https://get.k3s.io | sudo INSTALL_K3S_VERSION=${TEMP_VERSION} sh -
else
    sudo curl -sfL https://get.k3s.io | sudo sh -
fi

read -p "[INFO] Enter any character or string to copy config to ~/.kube/config (leave blank to skip): " TEMP_CONFIG
if [ $TEMP_CONFIG ]; then
    TEMP_HOME=$HOME
    TEMP_USER=$USER
    sudo cp /etc/rancher/k3s/k3s.yaml $TEMP_HOME/.kube/config
    sudo chown $TEMP_USER:$TEMP_USER $TEMP_HOME/.kube/config
    chmod 600 $TEMP_HOME/.kube/config
    printf "[INFO] Config file location: $TEMP_HOME/.kube/config\n"
else
    printf "[INFO] Config file location: /etc/rancher/k3s/k3s.yaml\n"
    printf "[INFO] You may want to execute: export KUBECONFIG=/etc/rancher/k3s/k3s.yaml\n"
fi
