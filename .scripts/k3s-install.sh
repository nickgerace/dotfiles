#!/usr/bin/env bash
if [ ! "$(command -v kubectl)" ] || [ ! "$(command -v docker)" ] || [ ! "$(command -v helm)" ]; then
    printf "Required dependencies: kubectl docker helm\n"
    exit 1
fi
curl -sfL https://get.k3s.io | sh -
mkdir ${HOME}/.kube/
cp /etc/rancher/k3s/k3s.yaml ${HOME}/.kube/config
