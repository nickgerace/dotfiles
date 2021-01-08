#!/usr/bin/env bash
if [ ! "$(command -v kubectl)" ] || [ ! "$(command -v docker)" ] || [ ! "$(command -v helm)" ]; then
    printf "Recommended dependencies: kubectl docker helm\n"
    exit 1
fi
if [ $1 ]; then
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${1} sh -
else
    curl -sfL https://get.k3s.io | sh -
fi
printf "\nConfig file location: /etc/rancher/k3s/k3s.yaml\n"
