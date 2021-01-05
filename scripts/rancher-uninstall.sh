#!/usr/bin/env bash
CM_VERSION=v0.15.0
NS_CM=cert-manager
NS_RANCHER=cattle-system
helm uninstall -n ${NS_RANCHER} rancher
kubectl delete namespace ${NS_RANCHER}
helm uninstall -n ${NS_CM} cert-manager
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/${CM_VERSION}/cert-manager.crds.yaml
kubectl delete namespace ${NS_CM}
