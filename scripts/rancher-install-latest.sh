#!/usr/bin/env bash
set -e

function check-binary {
    if [ ! $(command -v $1) ]; then
        echo "[rancher-install] command not found: $1"
        exit 1
    fi
}

function do-sleep {
    local SLEEP_SEC=15
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
    local CM_NAMESPACE=cert-manager
    local CM_VERSION=v1.5.1

    kubectl create -f https://github.com/jetstack/cert-manager/releases/download/$CM_VERSION/cert-manager.crds.yaml
    kubectl create namespace $CM_NAMESPACE
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager -n $CM_NAMESPACE --version $CM_VERSION

    kubectl rollout status deployment cert-manager -n $CM_NAMESPACE
    kubectl rollout status deployment cert-manager-webhook -n $CM_NAMESPACE
    kubectl rollout status deployment cert-manager-cainjector -n $CM_NAMESPACE
}

function install-rancher  {
    local RANCHER_NAMESPACE=cattle-system
    kubectl create namespace $RANCHER_NAMESPACE
    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
    helm repo update
    helm install rancher rancher-latest/rancher -n $RANCHER_NAMESPACE \
        --set ingress.tls.source=rancher \
        --set hostname=$1 \
        --set rancherImagePullPolicy=Always \
        --set replicas=3
    kubectl rollout status deploy/rancher -n $RANCHER_NAMESPACE
}

if [ ! $1 ] || [ ! $2 ]; then
    echo "[rancher-install] required argument: <hostname-without-http>"
    exit 1
fi

check-binary kubectl
check-binary curl
check-binary helm
check-binary jq
set-kubeconfig

install-cert-manager
do-sleep
install-rancher $1
