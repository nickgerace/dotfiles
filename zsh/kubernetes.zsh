if [ "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
    alias k="kubectl"
    alias kfc="kubectl create -f"
    alias kfd="kubectl delete -f"
    alias kgn="kubectl get nodes"
    alias kgp="kubectl get pods"
    alias kgpa="kubectl get pods -A"
    alias kgns="kubectl get namespaces"
    alias kge="kubectl get events --all-namespaces  --sort-by='.metadata.creationTimestamp'"
    alias pods-on-nodes="kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces"

    if [ -d $HOME/.krew ]; then
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        alias krew-update="kubectl krew update && kubectl krew upgrade"
    fi
fi

alias ktx="kubectx"

if [ "$(command -v k3d)" ]; then
    alias kc="k3d cluster"
    alias kcl="k3d cluster list"
    alias kcc="k3d cluster create"
    alias kcd="k3d cluster delete"
    alias kcstart="k3d cluster start"
    alias kcstop="k3d cluster stop"
fi

function kubectl-exec {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <namespace> <pod>\n"
    else
        kubectl -n ${1} exec --stdin --tty ${2} -- /bin/bash
    fi
}

function kubectl-exec-windows {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <namespace> <pod>\n"
    else
        kubectl -n ${1} exec --stdin --tty ${2} -- powershell.exe
    fi
}

function k3d-create {
    if [ ! $1 ]; then
        printf "argument(s): <name> <optional-k8s-semver-x.x.x>\n"
    elif [ ! $2 ]; then
        k3d cluster create ${1}
    else
        K3S_IMAGE=rancher/k3s:v${2}-k3s2
        docker pull $K3S_IMAGE
        k3d cluster create ${1} --image $K3S_IMAGE
    fi
}

function kubectl-all-images {
    kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c
}

function kube-status {
    kubectl cluster-info
    kubectl get cs
}

function kube-config-combine {
    if [ ! $1 ]; then
        printf "Requires argument(s): <path-to-other-config>\n"
    elif ! [ -f $HOME/.kube/config ]; then
        printf "Requires $HOME/.kube/config to exist.\n"
    else
        printf "Combining $HOME/.kube/config and $1 ...\n"
        if [ -f $HOME/.kube/config-new ]; then rm $HOME/.kube/config-new; fi
        KUBECONFIG=$HOME/.kube/config:$1 kubectl config view --flatten > $HOME/.kube/config-new
        mv $HOME/.kube/config-new $HOME/.kube/config
        chmod 600 $HOME/.kube/config
        rm -i $1
    fi
}
