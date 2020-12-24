#!/usr/bin/env bash
if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
    printf "Need k3s installed first!\n"
    exit 1
fi

TAG=v2.5-head
if [ $1 ]; then
    TAG="${1}"
fi

if [ $2 ]; then
    docker run -d --restart=unless-stopped \
        -p 80:80 -p 443:443 \
        -v /etc/rancher/k3s/k3s.yaml:/etc/rancher/k3s/k3s.yaml \
        -e HTTP_PROXY="http://${2}:6443" \
        -e HTTPS_PROXY="http://${2}:6443" \
        -e NO_PROXY="localhost,127.0.0.1,0.0.0.0,10.0.0.0/8,192.168.10.0/24,.svc,.cluster.local,example.com" \
        -e KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
        --privileged \
        rancher/rancher:${TAG}
else
    docker run -d --restart=unless-stopped \
        -p 80:80 -p 443:443 \
        -v /etc/rancher/k3s/k3s.yaml:/etc/rancher/k3s/k3s.yaml \
        -e KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
        --privileged \
        rancher/rancher:${TAG}
fi
