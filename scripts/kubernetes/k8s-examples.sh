#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "requires argument: <namespace>"
    exit 1
fi
kubectl get namespaces $1
if [ $? -ne 0 ]; then
    kubectl create namespace $1
    echo "created namespace: $1"
fi
kubectl create -f https://kubernetes.io/examples/controllers/job.yaml -n $1
kubectl create -f https://k8s.io/examples/controllers/nginx-deployment.yaml -n $1
