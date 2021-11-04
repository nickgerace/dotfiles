if [ "$(command -v k3d)" ]; then
    alias kcl="k3d cluster list"
    alias kcd="k3d cluster delete"
    alias kcda="k3d cluster delete --all"

    function kcc {
        if [ ! $1 ]; then
            echo "required argument: <stable/latest>"
        elif [ "$1" = "stable" ]; then
            k3d cluster create $(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-7) --image rancher/k3s:$(curl -s https://update.k3s.io/v1-release/channels | jq -r '.data[] | select(.id == "v1.21").latest' | sed 's/+/-/')
        elif [ "$1" = "latest" ]; then
            k3d cluster create $(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-7)
        else
            echo "invalid argument provided"
        fi
    }
fi
