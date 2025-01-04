setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' on %B%F{green}%b%f'
precmd() { vcs_info }

# The PROMPT must use single quotes in order to properly work, which includes updating "vcs_info"
PROMPT='%B%F{blue}%~%f%b${vcs_info_msg_0_} %b(%B%F{magenta}%m%f%b)
%(?.%B%F{green}❯%f%b.%B%F{red}❯%f%b) '
