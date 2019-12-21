#!/usr/bin/env bash

# ======================
#         BASHRC
# https://nickgerace.dev
# ======================

# Display 256 colors.
export TERM=xterm-256color

# Set go path.
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# Set autocolors if they are available on the OS.
if [[ -x /usr/bin/dircolors ]]; then
    alias ls="ls --color=auto"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# Load aliases if file exists and is readable.
if [[ -f ~/.aliases.bash ]]; then source ~/.aliases.bash; fi

# Load bash completion when available.
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/profile.d/bash_completion.sh ]]; then
    source /etc/profile.d/bash_completion.sh
else
    echo "Unable to start bash completion."
fi

# Add Kubectl autocompletion if installed.
if type kubectl &> /dev/null; then
    source <(kubectl completion bash)
    alias k='kubectl'
    complete -F __start_kubectl k
fi

# Add Kubebuilder to path.
export PATH=$PATH:/usr/local/kubebuilder/bin

# Setup Ruby environment.
if [[ -d $HOME/.rbenv/bin ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# Set default editor to vim.
export VISUAL=vim
export EDITOR="$VISUAL"

# Optional: tools and startup utilities.
# if type neofetch &> /dev/null; then neofetch; fi
# if type exa &> /dev/null; then alias lls="exa"; fi

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
