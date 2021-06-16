#!/usr/bin/env bash
set -e

printf "[WRAPPER]  If inputting a release version, use a valid tag: https://github.com/k3s-io/k3s/tags\n"
read -p "[WRAPPER]  Input a tag (leave blank to use latest stable): " TEMP_VERSION
if [ $TEMP_VERSION ]; then
    printf "[WRAPPER]  Running with version: $TEMP_VERSION\n"
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${TEMP_VERSION} sh -
else
    curl -sfL https://get.k3s.io | sh -
fi

read -p "[WRAPPER]  Enter any character/string to copy config to ~/.kube/config (leave blank to skip): " TEMP_CONFIG
if [ $TEMP_CONFIG ]; then
    TEMP_HOME=$HOME
    TEMP_USER=$USER
    HOME_CONFIG_DIR=$TEMP_HOME/.kube
    HOME_CONFIG=$HOME_CONFIG_DIR/config

    if [ ! -d $HOME_CONFIG_DIR ]; then mkdir -p $HOME_CONFIG_DIR; fi
    if [ -f $HOME_CONFIG ]; then rm $HOME_CONFIG ; fi
    cp /etc/rancher/k3s/k3s.yaml $HOME_CONFIG
    chown $TEMP_USER:$TEMP_USER $HOME_CONFIG
    chmod 600 $HOME_CONFIG
    printf "[WRAPPER]  Config file location: $HOME_CONFIG\n"
else
    printf "[WRAPPER]  Config file location: /etc/rancher/k3s/k3s.yaml\n"
    printf "[WRAPPER]  You may want to execute: export KUBECONFIG=/etc/rancher/k3s/k3s.yaml\n"
fi
