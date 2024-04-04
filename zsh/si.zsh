function start-work {
    ulimit -n 10240
    cd ~/src/si
    tmux
}

function si-branches {
    echo ""

    for branch in $(git branch); do
        if [[ $branch != *"*"* ]] && [[ $branch != "main" ]]; then
            echo "  $branch    $(git log -1 --pretty=format:%s $branch)"
        fi
    done

    echo ""

    for branch in $(git branch -a); do
        if [[ $branch == *"origin"* ]] && [[ $branch == *"nick"* ]]; then
            echo "  $branch    $(git log -1 --pretty=format:%s $branch)"
        fi
    done

    echo ""
}
