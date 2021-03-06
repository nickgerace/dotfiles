#!/usr/bin/env bash
if [ -z "$1" ]; then
    printf "Requires argument(s): <namespace>\n"
    exit 1
fi
kubectl get namespaces ${1}
if [ $? -ne 0 ]; then
    printf "Creating namespace: ${1} ...\n"
    kubectl create namespace ${1}
fi
kubectl create -f https://kubernetes.io/examples/controllers/job.yaml -n ${1}
kubectl create -f https://k8s.io/examples/controllers/nginx-deployment.yaml -n ${1}
