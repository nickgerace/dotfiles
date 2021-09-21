#!/usr/bin/env bash
set +x
kubectl get clusters.fleet.cattle.io -A
kubectl get clusters.provisioning.cattle.io -A
kubectl get clusters.management.cattle.io
