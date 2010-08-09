export ZSH_HOME=$HOME/.zsh

typeset -ga preexec_functions
typeset -ga precmd_functions

. $ZSH_HOME/appearance
. $ZSH_HOME/config
. $ZSH_HOME/aliases
. $ZSH_HOME/completion

# source files (no dirs)
for source_file ($ZSH_HOME/source.d/*) source $source_file

# use .zshlocalrc for settings specific to one system
[[ -f ~/.zshlocalrc ]] && . ~/.zshlocalrc
