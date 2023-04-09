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
    alias kubectl-get-pods-on-nodes="kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces"
    alias kubectl-api-logs="kubectl get --raw=/apis"
    alias kubectl-apiserver-log="kubectl get --raw=/logs/kube-apiserver.log"

    function kubectl-exec {
        if [ ! $1 ] || [ ! $2 ]; then
            echo "required arguments: <namespace> <pod>"
            return
        fi
        kubectl -n ${1} exec --stdin --tty ${2} -- /bin/bash
    }

    function kubectl-exec-windows {
        if [ ! $1 ] || [ ! $2 ]; then
            echo "required arguments: <namespace> <pod>"
            return
        fi
        kubectl -n ${1} exec --stdin --tty ${2} -- powershell.exe
    }

    function kubectl-all-images {
        kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c
    }

    function kubectl-cluster-status {
        kubectl cluster-info
        kubectl get cs
    }

    function kube-config-combine {
        if [ ! $1 ]; then
            echo "required arguments: <path-to-new-config>"
            return
        fi

        local CONFIG=$HOME/.kube/config
        mkdir -p $HOME/.kube/
        if [ -f $CONFIG ]; then
            rm $CONFIG
        fi

        KUBECONFIG=$1:$2 kubectl config view --flatten > $CONFIG
        chmod 600 $CONFIG
        rm -i $1 $2
    }

    function kubectl-get-pods-names-only {
        if [ $1 ]; then
            kubectl get pods -n $1 --no-headers -o custom-columns=":metadata.name"
        else
            kubectl get pods -A --no-headers -o custom-columns=":metadata.namespace,:metadata.name"
        fi
    }

    function kubectl-download-crd {
        if [ ! $1 ]; then
            echo "required argument: <api-resource-plural-name>"
            return
        fi
        kubectl get crd $1 -o yaml > $1.yaml
    }

    if [ -d $HOME/.krew ]; then
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        alias krew-update="kubectl krew update && kubectl krew upgrade"
    fi
fi

if [ "$(command -v kubectx)" ]; then
    alias ktx="kubectx"
    alias ktxd="kubectx -d"
fi
