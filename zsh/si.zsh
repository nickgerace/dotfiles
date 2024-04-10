function start-work {
    ulimit -n 10240
    cd ~/src/si
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
