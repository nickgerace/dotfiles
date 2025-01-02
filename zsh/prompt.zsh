# This uses catppuccin latte colors: https://github.com/catppuccin/catppuccin
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' on %B%F{#40a02b}%b%f'
precmd() { vcs_info }

# Colors for catppuccin-latte (light)
# Source: https://catppuccin.com/palette
# SAPPHIRE="#209fb5"
# MAUVE="#8839ef"
# GREEN="#40a02b"
# RED="#d20f39"

# Colors for catppuccin-frappe (dark)
# Source: https://catppuccin.com/palette
SAPPHIRE="#85c1dc"
MAUVE="#ca9ee6"
GREEN="#a6d189"
RED="#e78284"

# The PROMPT must use single quotes in order to properly work, which includes updating "vcs_info".
PROMPT='%B%F{$SAPPHIRE}%~%f%b${vcs_info_msg_0_} %b(%B%F{$MAUVE}%m%f%b)
%(?.%B%F{$GREEN}❯%f%b.%B%F{$RED}❯%f%b) '
