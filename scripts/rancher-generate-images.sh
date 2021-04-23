#!/usr/bin/env bash
# https://github.com/rancher/rancher/wiki/Generating-Image-Lists-Locally-for-Airgap-and-More
set -ex

# Change these values to your needs and liking.
#RANCHER=$HOME/github.com/rancher/rancher
RANCHER=$HOME/github.com/thedadams/rancher
RANCHER_SYSTEM_CHARTS=$HOME/github.com/rancher/system-charts
RANCHER_CHARTS=$HOME/github.com/nickgerace/rancher-charts/assets
RANCHER_METADATA_BRANCH=dev-v2.5
RANCHER_SYSTEM_CHARTS_BRANCH=dev-v2.5
RANCHER_CHARTS_BRANCH=dev-v2.5
SERVER_TAG=v2.5-head
AGENT_TAG=v2.5-head

function check-branch {
    if [ "$(cd $1; git branch --show-current)" != "$2" ]; then
        printf "Current branch at $1 does not match expected branch: $2\n"
        exit 1
    fi
}

# Add the "-i" flag before "rm" if you'd like to protect against accidental deletion.
[ ! -d $HOME/bin ] && mkdir -p $HOME/bin
[ -f $HOME/bin/data.json ] && rm $HOME/bin/data.json

check-branch $RANCHER_SYSTEM_CHARTS $RANCHER_SYSTEM_CHARTS_BRANCH
check-branch $RANCHER_CHARTS $RANCHER_CHARTS_BRANCH

curl -sLf https://releases.rancher.com/kontainer-driver-metadata/${RANCHER_METADATA_BRANCH}/data.json > $HOME/bin/data.json

cd $RANCHER
REPO=rancher TAG=dev go run $RANCHER/pkg/image/export/main.go \
    $RANCHER_SYSTEM_CHARTS $RANCHER_CHARTS \
    rancher/rancher:$SERVER_TAG rancher/rancher-agent:$AGENT_TAG
