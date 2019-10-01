# ======================
#         ZSHRC
# https://nickgerace.dev
# ======================

# Add 256 color Support
export TERM=xterm-256color

# My custom prompt.
PROMPT="%F{green}%n%f at %F{cyan}%m%f in %F{magenta}%~%f
λ "

# Load custom aliases file
if [ -f ~/.aliases.sh ]; then . ~/.aliases.sh; fi

# Set default editor to vim
export VISUAL=vim
export EDITOR="$VISUAL"
