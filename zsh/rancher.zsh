if [ -d "/usr/local/opt/yq@3/bin" ]; then
    export PATH="/usr/local/opt/yq@3/bin:$PATH"
fi

alias ngrok-rancher="ngrok http https://localhost:8443"
alias k3s-uninstall="k3s-uninstall.sh"

function rc-logging {
    if [ ! $1 ]; then
        printf "Required argument(s): <command>\nExample commands: prepare patch clean charts\n"
        return
    fi
    ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=rancher-logging make ${1} )
}

function rc-fleet {
    if [ ! $1 ]; then
        printf "Required argument(s): <command>\nExample commands: prepare patch clean charts\n"
    else
        ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=fleet make ${1} )
        ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=fleet-crd make ${1} )
        ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=fleet-agent make ${1} )
    fi
}

function fleet-update-rc-charts {
    if [ ! $1 ] || [ ! $2 ]; then
        echo "Required arguments: <old-rc-single-digit> <new-rc-single-digit>"
        return
    fi
    local PACKAGES=$HOME/github.com/nickgerace/rancher-charts/packages
    for i in $(find $PACKAGES/fleet-agent -type f) $(find $PACKAGES/fleet -type f) $(find $PACKAGES/fleet-crd -type f); do
        for j in "s/rc$1/rc$2/g" "s/^releaseCandidateVersion:.*$/releaseCandidateVersion: 0$2/g"; do
            gsed -i "$j" $i
        done
    done
}

function rc-backup {
    if [ ! $1 ]; then
        printf "Required argument(s): <command>\nExample commands: prepare patch clean charts\n"
    else
        ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=rancher-backup make ${1} )
        ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=rancher-backup-crd make ${1} )
    fi
}

function rancher-ci {
    local DIR=$HOME/github.com/rancher/rancher
    if [ $1 ]; then
        DIR=$1
    fi
    ( cd $DIR; DRONE_TAG=local-test TAG=local-test drone exec --event=pull_request --trusted --pipeline=default-linux-amd64 )
}

function rancher-build {
    local NAME=rancher
    k3d cluster delete $NAME
    if [ $1 ]; then
        local K3S_IMAGE=rancher/k3s:v${1}-k3s1
        docker pull $K3S_IMAGE
        k3d cluster create $NAME --image $K3S_IMAGE
    else
        k3d cluster create $NAME
    fi

    CATTLE_DEV_MODE=30 KUBECONFIG=$HOME/.kube/config go build -o $NAME -v -i -gcflags="-N -l" main.go
    CATTLE_DEV_MODE=30 KUBECONFIG=$HOME/.kube/config ./$NAME --add-local=true --no-cacerts
}

function docker-run-rancher {
    if [ ! $1 ] || [ "$1" = "" ]; then
        echo "argument required: <rancher-tag>"
        echo "options: master-head latest <dockerhub-tag>"
        return
    fi
    docker run -d --restart=unless-stopped --privileged \
        -p 80:80 -p 443:443 \
        -e CATTLE_BOOTSTRAP_PASSWORD=admin \
        rancher/rancher:$1
}

function docker-upgrade-rancher {
    if [ ! $1 ] || [ ! $2 ]; then
        echo "required argument: <rancher-container-name> <new-tag> <optional-volume-name>"
        return
    fi
    local VOLUME_NAME=rancher-data
    if [ $3 ] && [ "$3" != "" ]; then
        VOLUME_NAME=$3
    fi
    local OLD_TAG=$(docker container inspect $1 | jq ".[0].Config.Image" | tr -d '"' | cut -d ":" -f2)

    docker stop $1
    docker create --volumes-from $1 --name rancher-data rancher/rancher:$OLD_TAG
    docker run -d --restart=unless-stopped --privileged \
        --volumes-from $VOLUME_NAME \
        -p 80:80 -p 443:443 \
        -e CATTLE_BOOTSTRAP_PASSWORD=admin \
        rancher/rancher:$2
}
