# Changes and additions to oh-my-zsh's aliases
unalias gst
alias gs='git status'
compdef _git gs=git-status

unalias gl
alias gpl='git pull'
compdef _git gpl=git-pull

unalias gp
alias gpu='git push'
compdef _git gpu=git-push

alias gst='git stash save'
unalias gsta
alias gsta='git stash apply'

alias gae='git add --edit'
compdef _git gae=git-add
alias gf='git fetch'
compdef _git gf=git-fetch
alias grb='git rebase'
compdef _git grb=git-rebase
