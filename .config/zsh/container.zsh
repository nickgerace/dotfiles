# ZSH CONTAINER
# https://nickgerace.dev

# Set Docker aliases, and helpful commands.
alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

# Alias ready-to-use container images.
alias run-newest-ubuntu="docker run -it ubuntu:rolling"

# Add Kubernetes aliases, and setup kubectl autocompletion.
if [ "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
    alias k="kubectl"
    alias kgn="kubectl get nodes"
    alias kgp="kubectl get pods"
    alias kgpa="kubectl get pods -A"
    alias kgns="kubectl get namespaces"

    # Within kubectl settings, check if krew is installed. If so, add its settings.
    if [ -d $HOME/.krew ]; then
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        alias krew-update="kubectl krew update && kubectl krew upgrade"
    fi
fi

