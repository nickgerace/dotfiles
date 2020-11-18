# BASH CONTAINER
# https://nickgerace.dev

alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

alias run-newest-ubuntu="docker run -it ubuntu:rolling"

if [ "$(command -v kubectl)" ]; then
    source <(kubectl completion bash)
    alias k="kubectl"
    complete -F __start_kubectl k
    alias kgn="kubectl get nodes"
    alias kgp="kubectl get pods"
    alias kgpa="kubectl get pods -A"
    alias kgns="kubectl get namespaces"

    if [ -d $HOME/.krew ]; then
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        alias krew-update="kubectl krew update && kubectl krew upgrade"
    fi
fi

if [ "$(command -v k3d)" ]; then
    alias kc="k3d cluster"
    alias kcl="k3d cluster list"
    alias kcc="k3d cluster create"
    alias kcd="k3d cluster delete"
    alias kcstart="k3d cluster start"
    alias kcstop="k3d cluster stop"
fi

function docker-stop-and-rm-all-containers {
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
}

function kubectl-exec {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Requires argument(s): <namespace> <pod>\n"
    else
        kubectl -n ${1} exec --stdin --tty ${2} -- /bin/bash
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
