#!/usr/bin/env bash

# ======================
#         BASHRC
# https://nickgerace.dev
# ======================

# Display 256 colors.
export TERM=xterm-256color

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
if [[ -r ~/.aliases.bash ]]; then source ~/.aliases.bash; fi

# Load completion on Fedora and other RPM distros.
if [[ -r /etc/profile.d/bash_completion.sh ]]; then source /etc/profile.d/bash_completion.sh; fi

# Kubectl autocompletion.
source <(kubectl completion bash)

# Set default editor to vim.
export VISUAL=vim
export EDITOR="$VISUAL"

# Check if neofetch exists. If it does, execute.
if type neofetch &> /dev/null; then neofetch; fi

# Check if exa exists. If so, replace ls with it.
if type exa &> /dev/null; then alias ls="exa"; fi

# If tput colors are available, use them. Otherwise, use ASCII colors.
if tput setaf 1 &> /dev/null; then
    reset=$(tput sgr0)
    blue=$(tput setaf 33)
    green=$(tput setaf 64)
    violet=$(tput setaf 61)
else
    reset="\[\e[m\]"
    blue="\[\e[36m\]"
    green="\[\e[32m\]"
    violet="\[\e[35m\]"
fi

# Finally, display the prompt.
export PS1="${violet}\u${reset} at ${green}\h${reset} in ${blue}\w${reset}\nλ "
