if [ -d "$HOME/go" ]; then
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOBIN
    export PATH=$PATH:/usr/local/go/bin
    export PATH=${GOPATH//://bin:}/bin:$PATH
fi

if [ "$(command -v rg)" ]; then
    alias rg-go="rg -g '*.go' -g '!zz*.go' -g '!*generated' --sort path"
fi

if [ "$(command -v go)" ]; then
    alias gr="go run"
    alias grm="go run main.go"

    function go-mod-vendor {
        if [ ! $1 ] || [ ! $2 ]; then
            echo "required arguments: <module-url> <git-hash>"
        fi
        go get ${1}@${2}
        go mod vendor
    }

    if [ "$(command -v docker)" ]; then
        alias docker-run-golangci-lint="docker run --rm -v $(pwd):/app -w /app golangci/golangci-lint:latest golangci-lint"
    fi
fi