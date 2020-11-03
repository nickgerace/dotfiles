# BASH PROMPT
# https://nickgerace.dev

# 59   Grey37         #5f5f5f  rgb(95,95,95)
# 61   SlateBlue3     #5f5faf  rgb(95,95,175)
# 71   DarkSeaGreen4  #5faf5f  rgb(95,175,95)
# 131  IndianRed      #af5f5f  rgb(175,95,95)

function build_prompt {
	RET="$?"
	reset=$(tput sgr0)
	grey=$(tput setaf 59)
	blue=$(tput setaf 61)
	green=$(tput setaf 71)
	red=$(tput setaf 131)
	if [ ${RET} -eq 0 ]; then
		EXIT="(${green}${RET}${reset})"
	else
		EXIT="(${red}${RET}${reset})"
	fi
	if git rev-parse --git-dir > /dev/null 2>&1; then
		BRANCH="(${grey}$(git branch --show-current)${reset})"
	else
		BRANCH=""
	fi
	PS1="[${red}\u${reset} at ${green}\h${reset} in ${blue}\w${reset}] ${EXIT} ${BRANCH}\n\\$ "
}

export PROMPT_COMMAND=build_prompt

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
