#!/usr/bin/env bash

# ======================
#         BASHRC
# https://nickgerace.dev
# ======================

# Display 256 colors.
export TERM=xterm-256color

# Set default editor to vim.
export VISUAL=vim
export EDITOR="$VISUAL"

# Change history format to include timestamps.
export HISTTIMEFORMAT="%d/%m/%y %T | "

# Set Go path and add local installation of Go.
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# Add Kubebuilder to path.
export PATH=$PATH:/usr/local/kubebuilder/bin

# Add NodeJS to path.
export PATH=$PATH:/usr/local/nodejs/bin

# Install Ruby Gems to the gems directory.
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# Set Rust path in the cargo directory.
export PATH="$PATH:$HOME/.cargo/bin"

# Set autocolors if they are available on the OS.
if [[ -x /usr/bin/dircolors ]]; then
    alias ls="ls --color=auto"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

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

# Load bash completion when available.
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/profile.d/bash_completion.sh ]]; then
    source /etc/profile.d/bash_completion.sh
else
    echo "Unable to start bash completion."
fi

# Add kubectl autocompletion if installed.
# Then, add kubectl aliases.
if type kubectl &> /dev/null; then
    source <(kubectl completion bash)
    alias k='kubectl'
    alias kgn='kubectl get nodes'
    alias kgp='kubectl get pods'
    alias kgpa='kubectl get pods -A'
    complete -F __start_kubectl k
fi

# Setup Ruby environment.
if [[ -d $HOME/.rbenv/bin ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

# Vim aliases.
if type vim &> /dev/null; then
    alias update-vim-plugs='vim +PlugUpdate +qall'
    alias upgrade-vim-plugs='vim +PlugUpdate +PlugUpgrade +PlugClean +qall'
    alias vi='vim'
    alias v='vim'
    alias vvim='vim ~/.vimrc'
fi

# Firmware manager aliases.
if type fwdupmgr &> /dev/null; then
    alias update-firmware='fwupdmgr update'
    alias check-firmware='fwupdmgr get-devices'
fi

# Git aliases.
if type git &> /dev/null; then

    # General git aliases.
    alias g='git'
    alias gadd='git add'
    alias gcomm='git commit'
    alias gcommit='git commit'
    alias gdiff='git diff'
    alias gfetch='git fetch'
    alias gpo='git push origin'
    alias gpull='git pull'
    alias gstat='git status'
    alias git-store-credentials='git config credential.helper store'
    alias git-store-credentials-global='git config credential.helper store --global'
    alias reset-repo-to-last-commmit='git reset --hard'
    alias vgitconf='vim ~/.gitconfig'

    # Branch-related aliases.
    alias branch='git rev-parse --abbrev-ref HEAD'
    alias branches='git branch -a'
    alias branch-new='git checkout -b'
    alias branch-switch='git checkout'
    alias branch-delete='git branch -d'
fi

# Perforce aliases.
if type p4 &> /dev/null; then
    alias po='p4 opened'
fi

# Tmux aliases.
if type tmux &> /dev/null; then
    alias vtmux='vim ~/.tmux.conf'
    alias tmuxa='tmux attach -t'
fi

# Powerstat aliases.
if type powerstat &> /dev/null; then
    alias checkpower='powerstat -R -c -z'
fi

# Dig aliases.
if type dig &> /dev/null; then
    alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
fi

# Fdisk aliases.
if type fdisk &> /dev/null; then
    alias see-drives='sudo fdisk -l'
fi

# Exa aliases.
if type exa &> /dev/null; then
    alias x='exa'
fi

# Make aliases.
if type make &> /dev/null; then
    alias vmake='vim Makefile'
fi

# Go aliases.
if type go &> /dev/null; then
    alias gocode='cd $GOPATH/src/github.com/nickgerace'
fi

# Rust aliases.
if type cargo &> /dev/null; then
    alias cr='cargo run'
    alias crq='cargo run --quiet'
fi

# Minikube aliases.
if type minikube &> /dev/null; then
    alias minikube-start='minikube start --vm-driver virtualbox'
fi

# Docker aliases.
if type docker &> /dev/null; then
    alias d='docker'
    alias dlint='docker run --rm -i hadolint/hadolint < Dockerfile'
    alias dpurge='docker system purge'
    alias dpurge-all='docker system purge -a'
    alias dflask='docker run -dp 5000:5000'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias dimg='docker images'
    alias dfind='tree -P "Dockerfile"'
    alias drun='docker run'
    alias dc='docker-compose'
    alias run-newest-python='docker run -it python:rc-alpine'
    alias run-newest-golang='docker run -it golang:rc-alpine'
    alias run-newest-debian='docker run -it debian:unstable-slim'
    alias run-newest-ubuntu='docker run -it ubuntu:rolling'
fi

# After all other aliases, add helpful bash defaults.
alias vbash='vim ~/.bashrc'
alias vbashrc='vbash'
alias sbash='source ~/.bashrc'
alias sbashrc='sbash'
alias bye='sudo shutdown now'
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias del='rm -rfi'
alias h='history'
alias name='echo "> whomai" && whoami && echo "> hostname"&& hostname && echo "> hostname -f" && hostname -f'
alias check-os='cat /etc/os-release'
alias ping5='ping -c 5'
alias findalias='alias | grep'
alias count-directories='ls -d * | wc -l'
alias path='echo $PATH | sed "s/:/\n/g"'

# Other aliases.
if [[ -r ~/.aliases.bash ]]; then source ~/.aliases.bash; fi

# If tput colors are available, use them. Otherwise, use ASCII colors.
# Finally, display the prompt.
if tput setaf 1 &> /dev/null; then
    reset=$(tput sgr0)
    blue=$(tput setaf 33)
    green=$(tput setaf 64)
    violet=$(tput setaf 61)
    bold=$(tput bold)
    export PS1="${bold}${violet}\u${reset} at ${bold}${green}\h${reset} in ${bold}${blue}\w${reset}\n% "
else
    reset="\[\e[m\]"
    blue="\[\e[36m\]"
    green="\[\e[32m\]"
    violet="\[\e[35m\]"
    export PS1="${violet}\u${reset} at ${green}\h${reset} in ${blue}\w${reset}\n% "
fi
