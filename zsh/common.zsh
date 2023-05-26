export DOTFILES=$HOME/.dotfiles
export CACHEDIR=$HOME/.cache
export CONFIGDIR=$HOME/.config
export DATADIR=$HOME/.local/share

export XDG_CACHE_HOME=$CACHEDIR
export XDG_CONFIG_HOME=$CONFIGDIR
export XDG_DATA_HOME=$DATADIR

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

export HOMEBREW_PYTHON_VERSION="3.10"

# This must be set for asdf-direnv to work properly. The _load_asdf_utils
# function in asdf-direnv's command.bash is unable to determine the proper
# value for ASDF_DIR automatically.
export ASDF_DIR=$HOMEBREW_BASE/opt/asdf/libexec
export ASDF_DATA_DIR=$DATADIR/asdf

function is-darwin {
    [[ "$OSTYPE" == darwin* ]]
}

function is-linux {
    [[ "$OSTYPE" == linux* ]]
}
