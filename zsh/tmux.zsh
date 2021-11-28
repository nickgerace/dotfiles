if [ "$(command -v tmux)" ]; then
    alias tmuxa="tmux attach -t"
    alias tmuxk="tmux kill-session -t"
    alias tmuxn="tmux new -s"

    alias tmuxl="tmux ls"
    alias tl="tmux ls"
fi