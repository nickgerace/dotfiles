# ======================
#         ZSHRC
#      "Oh My ZSH"
# https://nickgerace.dev
# ======================

# Add 256 color Support
export TERM=xterm-256color

# Path to the oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set shell theme
ZSH_THEME="nickgerace"

# Add default git plugin
plugins=(git)

# Execute oh my zsh upon startup
source $ZSH/oh-my-zsh.sh

# Load custom aliases file
if [ -f ~/.aliases.sh ]; then . ~/.aliases.sh; fi

# Set default editor to vim
export VISUAL=vim
export EDITOR="$VISUAL"
