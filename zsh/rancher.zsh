if [ -d "/usr/local/opt/yq@3/bin" ]; then
    export PATH="/usr/local/opt/yq@3/bin:$PATH"
fi

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
        echo "Required arguments: <old-rc> <new-rc>"
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

