#!/usr/bin/env bash
if [ ! $1 ]; then
    printf "Requires argument(s): <subcommand>\n"
    exit 1
fi

if [ ! -f $HOME/.kube/config ]; then
    printf "File not found: ${HOME}/.kube/config\nTrying k3s..\n"
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
fi

if [ "$1" == "create" ] || [ "$1" == "install" ]; then
    if [ ! $2 ]; then
        printf "Requires argument(s): <rancher-ui-hostname>\n"
        exit 1
    fi

    kubectl create --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.crds.yaml
    kubectl create namespace cert-manager
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager -n cert-manager --version v0.15.0
    kubectl rollout status deployment cert-manager -n cert-manager
    kubectl rollout status deployment cert-manager-webhook -n cert-manager
    kubectl rollout status deployment cert-manager-cainjector -n cert-manager

    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
    kubectl create namespace cattle-system
    helm install rancher rancher-latest/rancher -n cattle-system --set hostname=${2}
    kubectl rollout status deploy/rancher -n cattle-system
elif [ "$1" == "delete" ] || [ "$1" == "uninstall" ]; then
    helm uninstall -n cattle-system rancher
    kubectl delete namespace cattle-system

    helm uninstall -n cert-manager cert-manager
    kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.crds.yaml
    kubectl delete namespace cert-manager
else
    printf "Possible subcommands: create/install delete/uninstall\n"
    exit 1
fi
