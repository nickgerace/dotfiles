#!/usr/bin/env bash
if [ ! "$(command -v kubectl)" ] || [ ! "$(command -v docker)" ] || [ ! "$(command -v helm)" ]; then
    printf "Recommended dependencies: kubectl docker helm\nSleeping 10 seconds for CTRL+C...\n"
    sleep 10
fi
curl -sfL https://get.k3s.io | sh -
printf "\nConfig file location: /etc/rancher/k3s/k3s.yaml\n"
