#!/usr/bin/env bash
if [ ! $1 ]; then
    printf "Argument(s): <subcommand>\n"
    exit 1
fi

if [ ! -f $HOME/.kube/config ]; then
    printf "File not found: ${HOME}/.kube/config\nTrying k3s..\n"
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
fi

CM_VERSION=v0.15.0
NS_CM=cert-manager
NS_RANCHER=cattle-system

if [ "$1" == "create" ] || [ "$1" == "install" ]; then
    if [ ! $2 ]; then
        printf "Argument(s): <rancher-ui-hostname> <optional-rancher-image-tag>\n"
        exit 1
    fi

    if [ $3 ]; then
        printf "Rancher image tag provided: ${3}\n"
        docker pull rancher/rancher:${3}
        if [ $? -ne 0 ]; then
            printf "Invalid image provided. Valid images: https://hub.docker.com/r/rancher/rancher/tags/\n"
            exit 1
        fi
    fi

    kubectl create --validate=false -f https://github.com/jetstack/cert-manager/releases/download/${CM_VERSION}/cert-manager.crds.yaml
    kubectl create namespace ${NS_CM}
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager -n ${NS_CM} --version ${CM_VERSION}
    kubectl rollout status deployment cert-manager -n ${NS_CM}
    kubectl rollout status deployment cert-manager-webhook -n ${NS_CM}
    kubectl rollout status deployment cert-manager-cainjector -n ${NS_CM}

    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
    kubectl create namespace ${NS_RANCHER}
    if [ $3 ]; then
        helm install rancher rancher-latest/rancher -n ${NS_RANCHER} \
            --set hostname=${2} \
            --set rancherImageTag=${3} \
            --set rancherImagePullPolicy=Always \
            --set replicas=1
    else
        helm install rancher rancher-latest/rancher -n ${NS_RANCHER} \
            --set hostname=${2} \
            --set rancherImagePullPolicy=Always \
            --set replicas=1
    fi
    kubectl rollout status deploy/rancher -n ${NS_RANCHER}
elif [ "$1" == "delete" ] || [ "$1" == "uninstall" ]; then
    helm uninstall -n ${NS_RANCHER} rancher
    kubectl delete namespace ${NS_RANCHER}

    helm uninstall -n ${NS_CM} cert-manager
    kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/${CM_VERSION}/cert-manager.crds.yaml
    kubectl delete namespace ${NS_CM}
else
    printf "Subcommand(s): create/install delete/uninstall\n"
    exit 1
fi
