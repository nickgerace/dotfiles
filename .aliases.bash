# ======================
#        ALIASES
# https://nickgerace.dev
# ======================

# Vim
alias update-vim-plugs='vim +PlugUpdate +qall'
alias upgrade-vim-plugs='vim +PlugUpdate +PlugUpgrade +PlugClean +qall'
alias vi='vim'
alias v='vim'
alias vvim='vim ~/.vimrc'

# Debian
alias sai='sudo apt install'
alias sar='sudo apt remove'
alias sau='sudo apt update'
alias sauu='sudo apt update && sudo apt upgrade -y'
alias saa='sudo apt autoremove -y'
alias sal='sudo apt list --upgradeable'
alias saduar='sadu && saa'
alias sas='sudo apt search'
alias apthistory='less /var/log/apt/history.log'

# Fedora
alias sdi='sudo dnf install -y'
alias sdr='sudo dnf remove -y'
alias sdu='sudo dnf upgrade -y --refresh'
alias sda='sudo dnf autoremove -y'
alias sdca='sudo dnf clean all -y'
alias sds='sudo dnf search'

# macOS
alias b='brew'
alias bd='brew doctor'
alias bu='brew update'
alias bup='brew upgrade'
alias buu='brew update && brew upgrade'
alias bs='brew search'
alias bclean='brew cleanup'

# Firmware
alias update-firmware='fwupdmgr update'
alias check-firmware='fwupdmgr get-devices'

# Git
alias g='git'
alias gadd='git add'
alias gcomm='git commit'
alias gcommit='git commit'
alias gdiff='git diff'
alias gfetch='git fetch'
alias gpom='git push origin master'
alias gpull='git pull'
alias gstat='git status'
alias git-store-credentials='git config credential.helper store'
alias branch='git rev-parse --abbrev-ref HEAD'
alias reset-repo-to-last-commmit='git reset --hard'

# Perforce
alias po='p4 opened'

# Tmux
alias vtmux='vim ~/.tmux.conf'

# Bash
alias vbash='vim ~/.bashrc'
alias sbash='source ~/.bashrc'

# Zsh
alias szsh='source ~/.zshrc'
alias vzsh='vim ~/.zshrc'

# Fish
alias vfish='vim ~/.config/fish/config.fish'
alias sfish='source ~/.config/fish/config.fish'

# Aliases
alias valiases='vim ~/.aliases.bash'

# Server
alias bye='sudo shutdown now'
alias checkpower='powerstat -R -c -z'
alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'

# General
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias del='rm -rfi'
alias h='history'
alias name='whoami && hostname && hostname -f'
alias vmake='vim Makefile'
alias see-drives='sudo fdisk -l'
alias check-os='cat /etc/os-release'
alias ping5='ping -c 5'
alias find-alias='alias | grep'
alias count-directories='ls -d * | wc -l'

# Docker
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

# Dockerfiles
alias run-newest-python='docker run -it python:rc-alpine'
alias run-newest-golang='docker run -it golang:rc-alpine'
alias run-newest-debian='docker run -it debian:unstable-slim'
alias run-newest-ubuntu='docker run -it ubuntu:rolling'

# Python
alias p='python3'
alias prun='python3'
alias pinstall='pip3 install'
alias fr='flask run'

# Go
alias gocode='cd $GOPATH/src/github.com/nickgerace'

# Kubernetes
alias k='kubectl'
alias kgn='kubectl get nodes'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias minikube-start='minikube start --vm-driver virtualbox'
