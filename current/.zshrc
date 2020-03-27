# ZSHRC
# https://nickgerace.dev

# Oh My Zsh defaults and options.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kphoen"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Terminal, editor and general settings.
export TERM=xterm-256color
export VISUAL=vim
export EDITOR="$VISUAL"
export HISTTIMEFORMAT="%d/%m/%y %T | "
export PATH=$PATH:/usr/local/bin

# Go settings and pathing.
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Rust settings and pathing.
export PATH=$PATH:$HOME/.cargo/bin
alias cr='cargo run'
alias crq='cargo run --quiet'
alias cb='cargo build'
alias cbr='cargo build --release'
alias vcargo='vim Cargo.toml'

# Ruby settings and pathing. If installed, set up the environment.
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
if [[ -d $HOME/.rbenv/bin ]]; then
    eval "$(rbenv init -)"
fi

# Misc local binaries.
export PATH=$PATH:/usr/local/kubebuilder/bin
export PATH=$PATH:/usr/local/nodejs/bin

# Kubernetes aliases and kubectl autocompletion.
if [ "$(command -v kubectl)" ]; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
fi
alias k='kubectl'
alias kgn='kubectl get nodes'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias minikube-start='minikube start --vm-driver virtualbox'

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
alias git-store-credentials='git config credential.helper store && printf "\nPlease switch to SSH!\n"'
alias git-store-credentials-global='git config credential.helper store --global && printf "\nPlease switch to SSH!\n"'
alias reset-repo-to-last-commmit='git reset --hard'
alias squash='printf "git reset --soft HEAD~N\n"'
alias vgitconf='vim $HOME/.gitconfig'

# Branch-related aliases.
alias branch='git branch'
alias branch-current='git rev-parse --abbrev-ref HEAD'
alias branches='git branch -a'
alias branch-new='git checkout -b'
alias branch-switch='git checkout'
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
alias x='exa'
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -la'
alias del='rm -ri'
alias rm='rm -i'
alias h='history'
alias name='echo "> whomai" && whoami && echo "> hostname"&& hostname && echo "> hostname -f" && hostname -f'
alias ping5='ping -c 5'
alias findalias='alias | grep'
alias count-directories='ls -d * | wc -l'
alias path='echo $PATH | sed "s/:/\n/g"'

# Load aliases based on distro.
if grep -q -E "ID=ubuntu|ID=debain" /etc/os-release; then
    alias sai='sudo apt install'
    alias sar='sudo apt remove'
    alias sau='sudo apt update'
    alias sauu='sudo apt update && sudo apt upgrade -y'
    alias saa='sudo apt autoremove -y'
    alias sal='sudo apt list --upgradeable'
    alias saduar='sadu && saa'
    alias sas='sudo apt search'
    alias apthistory='less /var/log/apt/history.log'
elif grep -q "ID=fedora" /etc/os-release; then
    alias sdi='sudo dnf install -y'
    alias sdr='sudo dnf remove -y'
    alias sdu='sudo dnf upgrade -y --refresh'
    alias sda='sudo dnf autoremove -y'
    alias sdca='sudo dnf clean all -y'
    alias sds='sudo dnf search'
fi

# Hardware management aliases (Linux only).
alias update-firmware='fwupdmgr update'
alias check-firmware='fwupdmgr get-devices'
alias checkpower='powerstat -R -c -z'
alias get-public-ip-address='dig +short myip.opendns.com @resolver1.opendns.com'
alias see-drives='sudo fdisk -l'
alias bye='sudo shutdown now'
alias check-os='cat /etc/os-release'
