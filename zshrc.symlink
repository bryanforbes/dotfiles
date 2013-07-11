export ZSH_HOME=$HOME/.zsh

. $ZSH_HOME/config

# use .zshlocalrc for settings specific to one system
[[ -f ~/.zshlocalrc ]] && . ~/.zshlocalrc

. $ZSH_HOME/appearance
. $ZSH_HOME/aliases
. $ZSH_HOME/completion

# source files (no dirs)
for source_file ($ZSH_HOME/source.d/*) source $source_file
