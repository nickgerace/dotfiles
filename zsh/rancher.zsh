if [ -d "/usr/local/opt/yq@3/bin" ]; then
    export PATH="/usr/local/opt/yq@3/bin:$PATH"
fi

alias ngrok-rancher="ngrok http https://localhost:8443"
alias k3s-uninstall="k3s-uninstall.sh"

function rc-logging {
    if [ ! $1 ]; then
        echo "required argument: <make-target-or-command>"
        return
    fi
    ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=rancher-logging make ${1} )
}

function rc-fleet {
    if [ ! -f index.yaml ]; then
        echo "current working directory must be the charts directory"
        return
    fi
    PACKAGE=fleet make charts
    git add .
    git commit
    PACKAGE=fleet-agent make charts
    git add .
    git commit --amend
    PACKAGE=fleet-crd make charts
    git add .
    git commit --amend
}

function rc-backup {
    if [ ! $1 ]; then
        echo "required argument: <make-target-or-command>"
        return
    fi
    ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=rancher-backup make ${1} )
    ( cd $HOME/github.com/nickgerace/rancher-charts; PACKAGE=rancher-backup-crd make ${1} )
}

function rancher-ci {
    local DIR=$HOME/github.com/rancher/rancher
    if [ $1 ]; then
        DIR=$1
    fi
    ( cd $DIR; DRONE_TAG=local-test TAG=local-test drone exec --event=pull_request --trusted --pipeline=default-linux-amd64 )
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
        --no-cacerts \
        rancher/rancher:$2
}

function rancher-run {
    if [ ! -f main.go ]; then
        echo "could not find main.go in current working directory"
        return
    fi
    CATTLE_DEV_MODE=30 KUBECONFIG=$HOME/.kube/config go build -o rancher -v -i -gcflags="-N -l" main.go
    CATTLE_DEV_MODE=30 KUBECONFIG=$HOME/.kube/config ./rancher --add-local=true --no-cacerts
}

function rancher-build-v2.6 {
    set -x
    RKE_VERSION="$(grep -m1 'github.com/rancher/rke' go.mod | awk '{print $2}')"
    DEFAULT_VALUES="{\"rke-version\":\"${RKE_VERSION}\"}"

    if [ "$1" != "skip-build" ]; then
        GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -tags k8s \
            -ldflags "-X github.com/rancher/rancher/pkg/version.Version=dev -X github.com/rancher/rancher/pkg/version.GitCommit=dev -X github.com/rancher/rancher/pkg/settings.InjectDefaults=$DEFAULT_VALUES -extldflags -static -s" \
            -o bin/rancher
    fi

    if [ ! -f bin/data.json ]; then
        curl -sLf https://releases.rancher.com/kontainer-driver-metadata/dev-v2.6/data.json > bin/data.json
    fi
    if [ ! -f bin/k3s-airgap-images.tar ]; then
        echo "file not found: bin/k3s-airgap-images.tar"
        return
    fi

    cp bin/rancher package/
    cp bin/data.json package/
    cp bin/k3s-airgap-images.tar package/

    docker build -t nickgerace/rancher:dev -f ./package/Dockerfile ./package
    docker push nickgerace/rancher:dev
    set +x
}

function rancher-test {
    if [ ! $1 ] || [ "$1" = "" ]; then
        echo "required argument: <pytest-name>"
        return
    fi
    ( cd tests/integration/suite; pytest -k $1 )
}
