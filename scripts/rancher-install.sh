#!/usr/bin/env bash
set -e

function check-binary {
    if [ ! $(command -v $1) ]; then
        echo "[rancher-install] command not found: $1"
        exit 1
    fi
}

function do-sleep {
    SLEEP_SEC=15
    echo "[rancher-install] sleeping for $SLEEP_SEC seconds..."
    sleep $SLEEP_SEC
}

function set-kubeconfig {
    read -p "[rancher-install] path to KUBECONFIG (leave blank to use KUBECONFIG default): " KUBE_CONFIG_PATH
    if [ $KUBE_CONFIG_PATH ]; then
        export KUBECONFIG=$KUBE_CONFIG_PATH
    fi
}

function install-cert-manager {
    local NS_CM=cert-manager
    local CM_VERSION=$(curl -s https://api.github.com/repos/jetstack/cert-manager/releases/latest | jq -r ".tag_name")

    kubectl create --validate=false -f https://github.com/jetstack/cert-manager/releases/download/${CM_VERSION}/cert-manager.crds.yaml
    kubectl create namespace ${NS_CM}
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager -n ${NS_CM}

    kubectl rollout status deployment cert-manager -n ${NS_CM}
    kubectl rollout status deployment cert-manager-webhook -n ${NS_CM}
    kubectl rollout status deployment cert-manager-cainjector -n ${NS_CM}
}

function install-rancher  {
    helm install rancher rancher-latest/rancher -n cattle-system \
        --create-namespace
        --set hostname=${1} \
        --set rancherImagePullPolicy=Always \
        --set replicas=1 \
        https://releases.rancher.com/server-charts/latest/rancher-${2}.tgz
    kubectl rollout status deploy/rancher -n ${NS_RANCHER}
}

if [ ! $1 ] || [ ! $2 ]; then
    echo "[rancher-install] required arguments: <hostname-without-http> <rancher-image-tag-x.x.x>"
    echo "[rancher-install] valid tags: https://hub.docker.com/r/rancher/rancher/tags"
    exit 1
fi

check-binary kubectl
check-binary helm
check-binary jq
set-kubeconfig

install-cert-manager
do-sleep
install-rancher $1 $2
