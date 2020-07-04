# ZSHRC
# https://nickgerace.dev

# Oh My Zsh defaults and options.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="nickgerace"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Terminal, editor and general settings.
export TERM=xterm-256color
export VISUAL=vim
export EDITOR="$VISUAL"
export HISTTIMEFORMAT="%d/%m/%y %T | "

# All "local" path additions.
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/local/bin

# Go settings and pathing.
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:/usr/local/go/bin

# Rust settings and pathing.
export PATH=$PATH:$HOME/.cargo/bin
if [ "$(command -v cargo)" ]; then
    alias cr='cargo run'
    alias crq='cargo run --quiet'
    alias cb='cargo build'
    alias cbr='cargo build --release'
    alias vcargo='vim Cargo.toml'
fi
if [ "$(command -v bat)" ]; then
    alias cat='bat -p'
    alias bat='bat --theme=ansi-light'
fi
if [ "$(command -v exa)" ]; then
    alias ls='exa'
    alias x='exa'
fi
if [ "$(command -v rg)" ]; then
    alias grep='rg'
    alias rgh='rg --hidden'
fi
if [ "$(command -v fd)" ]; then
    alias find='fd'
    alias fdh='fd --hidden'
fi

# Ruby settings and pathing. If installed, set up the environment.
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
if [[ -d $HOME/.rbenv/bin ]]; then
    eval "$(rbenv init -)"
fi

# Kubernetes aliases and kubectl autocompletion.
if [ "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
    alias k='kubectl'
    alias kgn='kubectl get nodes'
    alias kgp='kubectl get pods'
    alias kgpa='kubectl get pods -A'
fi

# Vim, tmux, make and shell aliases.
alias v='vim'
alias vi='vim'
alias vvim='vim $HOME/.vimrc'
alias vtmux='vvim $HOME/.tmux.conf'
alias tmuxa='tmux attach -t'
alias tmuxl='tmux ls'
alias tmuxn='tmux new -s'
alias tmuxk='tmux kill-session -t'
alias vmake='vim Makefile'
alias vzsh='vim $HOME/.zshrc'
alias szsh='source $HOME/.zshrc'
alias vprofile='vim $HOME/.profile'

# Git aliases.
alias g='git'
alias gadd='git add'
alias gcomm='git commit'
alias gcommit='git commit'
alias gcs='git commit -s'
alias gcomms='git commit -s'
alias gdiff='git diff'
alias gfetch='git fetch'
alias gpo='git push origin'
alias gpull='git pull'
alias gstat='git status'
alias reset-repo-to-last-commmit='git reset --hard'
alias squash='printf "git reset --soft HEAD~N\n"'
alias vgitconf='vim $HOME/.gitconfig'

# Branch-related aliases.
alias branch='git branch'
alias branch-current='git rev-parse --abbrev-ref HEAD'
alias branches='git branch -a'
alias branch-new='git checkout -b'
alias branch-delete='git branch -d'

# Docker aliases.
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias run-newest-ubuntu='docker run -it ubuntu:rolling'

# Misc aliases.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias rm='rm -i'
alias h='history'
alias ping5='ping -c 5'
alias findalias='alias | grep'
alias path='echo $PATH | sed "s/:/\n/g"'

# Hardware management aliases (Linux only).
alias update-firmware='fwupdmgr update'
alias check-firmware='fwupdmgr get-devices'
alias checkpower='powerstat -R -c -z'
alias get-public-ip-address='dig +short myip.opendns.com @resolver1.opendns.com'
alias see-drives='sudo fdisk -l'
alias bye='sudo shutdown now'
alias check-os='cat /etc/os-release'
