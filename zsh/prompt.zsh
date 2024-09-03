# This uses catppuccin latte colors: https://github.com/catppuccin/catppuccin
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' on %B%F{#40a02b}%b%f'
precmd() { vcs_info }

# The PROMPT must use single quotes in order to properly work, which includes updating "vcs_info".
PROMPT='%B%F{#209fb5}%~%f%b${vcs_info_msg_0_} %b(%B%F{#8839ef}%m%f%b)
%(?.%B%F{#40a02b}❯%f%b.%B%F{#d20f39}❯%f%b) '
