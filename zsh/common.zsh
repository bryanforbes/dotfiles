# common.zsh
# ============================================================================
# Sourced by: zprofile (and transitively by zshenv for non-login shells)
# Purpose: Define common environment variables and utility functions shared
#          across all shell configurations
#
# This file sets up:
#   - XDG Base Directory paths
#   - Homebrew base path detection
#   - Common utility functions (is-darwin, is-linux)
#
# Load order: Before zshrc, as part of environment setup
# ============================================================================

# Prevent multiple sourcing
if [[ -n "$_DOTFILES_COMMON_LOADED" ]]; then
    return
fi
typeset -g _DOTFILES_COMMON_LOADED=1

export DOTFILES=$HOME/.dotfiles
export CACHEDIR=$HOME/.cache
export CONFIGDIR=$HOME/.config
export DATADIR=$HOME/.local/share
export STATEDIR=$HOME/.local/state

export XDG_CACHE_HOME=$CACHEDIR
export XDG_CONFIG_HOME=$CONFIGDIR
export XDG_DATA_HOME=$DATADIR
export XDG_STATE_HOME=$STATEDIR

export ZCACHEDIR=$CACHEDIR/zsh
export ZDATADIR=$DATADIR/zsh
export ZPLUGDIR=$ZCACHEDIR/plugins
export ZCOMPDIR=$ZCACHEDIR/completions
export ZFUNCDIR=$ZDATADIR/functions

if [[ -d /home/linuxbrew ]]; then
    export HOMEBREW_BASE=/home/linuxbrew/.linuxbrew
elif [[ -d $HOME/.linuxbrew ]]; then
    export HOMEBREW_BASE=$HOME/.linuxbrew
elif [[ -d /opt/homebrew ]]; then
    export HOMEBREW_BASE=/opt/homebrew
else
    export HOMEBREW_BASE=/usr/local
fi

export HOMEBREW_PYTHON_VERSION="3.13"

function is-darwin {
    [[ "$OSTYPE" == darwin* ]]
}

function is-linux {
    [[ "$OSTYPE" == linux* ]]
}
