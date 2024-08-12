# NOTE(nick): this prompt uses catppuccin latte colors:
# - directory: sapphire
# - branch: pink
# - success prompt: green
# - fail prompt: red
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats 'on %B%F{#ea76cb}%b%f'
precmd() { vcs_info }

# NOTE(nick): the PROMPT must use single quotes in order to properly work, which includes updating "vcs_info".
PROMPT='%B%F{#209fb5}%~%f%b ${vcs_info_msg_0_}
%(?.%B%F{#40a02b}❯%f%b.%B%F{#d20f39}❯%f%b) '
