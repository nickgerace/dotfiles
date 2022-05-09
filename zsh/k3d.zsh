if [ "$(command -v k3d)" ]; then
    alias kcl="k3d cluster list"
    alias kcd="k3d cluster delete"
    alias kcda="k3d cluster delete --all"

    function kcc {
        k3d cluster create $(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-7)
    }
fi
