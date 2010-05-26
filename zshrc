export ZSH=$HOME/.zsh

. $ZSH/appearance
. $ZSH/config
. $ZSH/aliases
. $ZSH/completion

# source files (no dirs)
for source_file ($ZSH/source.d/*) source $source_file

# use .zshlocalrc for settings specific to one system
[[ -f ~/.zshlocalrc ]] && . ~/.zshlocalrc
