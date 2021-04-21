#!/usr/bin/env bash
# https://github.com/rancher/rancher/wiki/Generating-Image-Lists-Locally-for-Airgap-and-More
set -ex

# Change these values to your needs and liking.
RANCHER_SYSTEM_CHARTS=$HOME/github.com/rancher/system-charts
RANCHER_CHARTS=$HOME/github.com/rancher/charts
RANCHER_METADATA_BRANCH=dev-v2.5
RANCHER_SYSTEM_CHARTS_BRANCH=dev-v2.5
RANCHER_CHARTS_BRANCH=dev-v2.5
SERVER_TAG=v2.5-head
AGENT_TAG=v2.5-head

cd $(dirname "$0")

function check-branch {
    if [ "$(cd $1; git branch --show-current)" != "$2" ]; then
        printf "Current branch at $1 does not match expected branch: $2\n"
        exit 1
    fi
}

[ ! -d $HOME/bin ] && mkdir -p $HOME/bin
[ -f $HOME/bin/data.json ] && rm -i $HOME/bin/data.json

check-branch $RANCHER_SYSTEM_CHARTS $RANCHER_SYSTEM_CHARTS_BRANCH
check-branch $RANCHER_CHARTS $RANCHER_CHARTS_BRANCH

curl -sLf https://releases.rancher.com/kontainer-driver-metadata/${RANCHER_METADATA_BRANCH}/data.json > $HOME/bin/data.json
REPO=rancher TAG=dev go run $(dirname "$0"; pwd)/pkg/image/export/main.go $RANCHER_SYSTEM_CHARTS $RANCHER_CHARTS rancher/rancher:$SERVER_TAG rancher/rancher-agent:$AGENT_TAG
