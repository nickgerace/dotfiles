#!/usr/bin/env bash
set -e

echo "[k3s-install] if inputting a release version, use a valid tag: https://github.com/k3s-io/k3s/tags"
read -p "[k3s-install] input a tag (leave blank to use latest stable): " TEMP_VERSION
read -p "[k3s-install] enter any character/string to NOT copy config to ~/.kube/config (leave blank to skip): " DECLINE

if [ $TEMP_VERSION ]; then
    echo "[k3s-install] running with version: $TEMP_VERSION"
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${TEMP_VERSION} sh -
else
    curl -sfL https://get.k3s.io | sh -
fi

if [ $DECLINE ]; then
    echo "[k3s-install] config file location: /etc/rancher/k3s/k3s.yaml"
    echo "[k3s-install] you may want to execute: export KUBECONFIG=/etc/rancher/k3s/k3s.yaml"
else
    TEMP_HOME=$HOME
    TEMP_USER=$USER
    HOME_CONFIG_DIR=$TEMP_HOME/.kube
    HOME_CONFIG=$HOME_CONFIG_DIR/config

    if [ ! -d $HOME_CONFIG_DIR ]; then mkdir -p $HOME_CONFIG_DIR; fi
    if [ -f $HOME_CONFIG ]; then rm $HOME_CONFIG ; fi
    cp /etc/rancher/k3s/k3s.yaml $HOME_CONFIG
    chown $TEMP_USER:$TEMP_USER $HOME_CONFIG
    chmod 600 $HOME_CONFIG
    echo "[k3s-install] config file location: $HOME_CONFIG"
fi
