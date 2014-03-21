# only eval dircolors if it exists
if [[ -a "$(whence dircolors)" ]]; then
	eval $(dircolors)
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
done
PR_RESET="%{$reset_color%}"

PROMPT='${PR_GREEN}%n${PR_RESET} at ${PR_YELLOW}%m${PR_RESET} in ${PR_BLUE}${PWD/#$HOME/~}${PR_RESET}
$(git_prompt_info)%# '

ZSH_THEME_GIT_PROMPT_PREFIX=' (git) ['
ZSH_THEME_GIT_PROMPT_SUFFIX='] '
ZSH_THEME_GIT_PROMPT_DIRTY='!'
ZSH_THEME_GIT_PROMPT_CLEAN=''
