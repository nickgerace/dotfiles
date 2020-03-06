#!/usr/bin/env bash

# BASHRC
# https://nickgerace.dev

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# Update the windows and columns as necessary.
shopt -s checkwinsize

# Display 256 colors.
export TERM=xterm-256color

# Set default editor to neovim.
export VISUAL=nvim
export EDITOR="$VISUAL"

# Change history format to include timestamps.
export HISTTIMEFORMAT="%d/%m/%y %T | "

# Set Go path and add local installation of Go.
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# Add all binaries in the local path.
export PATH=$PATH:/usr/local/bin

# Add Kubebuilder to path.
export PATH=$PATH:/usr/local/kubebuilder/bin

# Add NodeJS to path.
export PATH=$PATH:/usr/local/nodejs/bin

# Install Ruby Gems to the gems directory.
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH

# Set Rust path in the cargo directory.
export PATH=$PATH:$HOME/.cargo/bin

# Add the Neovim path.
export PATH=$HOME/local/nvim/bin:$PATH

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
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/profile.d/bash_completion.sh ]; then
	source /etc/profile.d/bash_completion.sh
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    else
        echo "Unable to start bash completion."
    fi
fi

# Add kubectl autocompletion if installed.
if type kubectl &> /dev/null; then
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

# Setup Ruby environment.
if [[ -d $HOME/.rbenv/bin ]]; then
    eval "$(rbenv init -)"
fi

# Neovim aliases. Only use if neovim is installed.
if [ "$(command -v nvim)" ]; then
    alias update-nvim-plugs='nvim +PlugUpdate +qall'
    alias upgrade-nvim-plugs='nvim +PlugUpdate +PlugUpgrade +PlugClean +qall'
    alias neovim='nvim'
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
    alias vvim='nvim $HOME/.config/nvim/init.vim'
    alias vnvim='nvim $HOME/.config/nvim/init.vim'
fi

# Firmware manager aliases (Linux only).
alias update-firmware='fwupdmgr update'
alias check-firmware='fwupdmgr get-devices'

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
alias vgitconf='nvim $HOME/.gitconfig'

# Branch-related aliases.
alias branch='git branch'
alias branch-current='git rev-parse --abbrev-ref HEAD'
alias branches='git branch -a'
alias branch-new='git checkout -b'
alias branch-switch='git checkout'
alias branch-delete='git branch -d'

# Perforce aliases.
alias po='p4 opened'

# Tmux aliases.
alias vtmux='nvim $HOME/.tmux.conf'
alias tmuxa='tmux attach -t'

# Powerstat aliases.
alias checkpower='powerstat -R -c -z'

# Dig aliases.
alias get-public-ip-address='dig +short myip.opendns.com @resolver1.opendns.com'

# Fdisk aliases.
alias see-drives='sudo fdisk -l'

# Kubectl aliases.
alias k='kubectl'
alias kgn='kubectl get nodes'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'

# Exa aliases.
alias x='exa'

# Make aliases.
alias vmake='nvim Makefile'

# Go aliases.
alias gocode='cd $GOPATH/src/github.com/nickgerace'

# Rust aliases.
alias cr='cargo run'
alias crq='cargo run --quiet'

# Minikube aliases.
alias minikube-start='minikube start --vm-driver virtualbox'

# Docker aliases.
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

# After all other aliases, add helpful bash defaults.
alias vbash='nvim $HOME/.bashrc'
alias vbashrc='vbash'
alias sbash='source $HOME/.bashrc'
alias sbashrc='sbash'
alias vprofile='nvim $HOME/.profile'
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
if [ -r $HOME/.aliases.bash ]; then source $HOME/.aliases.bash; fi

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
