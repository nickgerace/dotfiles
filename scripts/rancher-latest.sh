#!/usr/bin/env bash
if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
    printf "Need k3s installed first!\n"
    exit 1
fi

TAG=v2.5-head
if [ $1 ]; then
    TAG="${1}"
fi

docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /etc/rancher/k3s/k3s.yaml:/etc/rancher/k3s/k3s.yaml \
  -e KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
  --privileged \
  rancher/rancher:${TAG}
