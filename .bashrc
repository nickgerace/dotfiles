#!/usr/bin/env bash

# ======================
#         BASHRC
# https://nickgerace.dev
# ======================

# Display 256 colors.
export TERM=xterm-256colors

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

# Makefile target autocompletion.
complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make

# Set default editor to vim.
export VISUAL=vim
export EDITOR="$VISUAL"

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
