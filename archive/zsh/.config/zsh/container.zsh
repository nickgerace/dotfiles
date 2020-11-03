# ZSH CONTAINER
# https://nickgerace.dev

alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

alias run-newest-ubuntu="docker run -it ubuntu:rolling"

if [ "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
    alias k="kubectl"
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
