# ZSH CONFIG
# https://nickgerace.dev

# 59   Grey37         #5f5f5f  rgb(95,95,95)
# 61   SlateBlue3     #5f5faf  rgb(95,95,175)
# 71   DarkSeaGreen4  #5faf5f  rgb(95,175,95)
# 131  IndianRed      #af5f5f  rgb(175,95,95)

# Selected colors: https://jonasjacek.github.io/colors/
# Found color triads: https://www.wolframalpha.com/

setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '(%F{59}%b%f)'
precmd() { vcs_info }

# The PROMPT must use single quotes in order to properly work, and update "vcs_info".
PROMPT='[%F{131}%n%f at %F{71}%m%f in %F{61}%~%f] (%(?.%F{71}%?%f.%F{131}%?%f)) ${vcs_info_msg_0_}
%# '

