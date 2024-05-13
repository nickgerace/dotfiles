function start-work {
    # File descriptor max set to 2^20
    ulimit -n 1048576
    cd ~/src/si
    direnv allow .
    tmux
}

function si-branches {
    function si-print-branch {
        echo "  ─ $branch"
        echo "    └── $(git log -1 --pretty=format:%s $branch)"


    }

    pushd ~/src/si

    echo ""
    echo "LOCAL"
    for branch in $(git branch); do
        if [[ $branch != *"*"* ]] && [[ $branch != "main" ]]; then
            si-print-branch $1
        fi
    done
    echo ""
    echo "REMOTE"
    for branch in $(git branch -a); do
        if [[ $branch == *"origin"* ]] && [[ $branch == *"nick"* ]]; then
            si-print-branch $1
        fi
    done
    echo ""

    popd
}

function si-wipe-cache {
    setopt PUSHDSILENT

    pushd /tmp
    for WIPE_NIX_SHELL in $(ls | rg "nix-shell\.."); do
        pushd $WIPE_NIX_SHELL
        for WIPE_CACHE_DIR in $(ls | rg ".\-cache\-."); do
            echo $WIPE_CACHE_DIR
            rm -r $WIPE_CACHE_DIR
        done
        popd
    done
    popd

    unsetopt PUSHDSILENT
}
