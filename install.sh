#!/bin/bash

if [[ "$OSTYPE" == linux* ]]; then
    if ! command -v git > /dev/null || ! command -v gcc > /dev/null || ! command -v curl > /dev/null; then
        echo "Installing system requirements..."
        sudo apt-add-repository -y ppa:git-core/ppa
        sudo apt-get update
        sudo apt-get install -y build-essential curl file git || true
    fi
fi

if [[ "$OSTYPE" == darwin* ]]; then
    UNAME_MACHINE="$(/usr/bin/uname -m)"
    
    if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
        HOMEBREW_BASE=/opt/homebrew
    else
        HOMEBREW_BASE=/usr/local
    fi
else
    HOMEBREW_BASE=/home/linuxbrew/.linuxbrew
fi

if [[ ! -f "$HOMEBREW_BASE/bin/brew" ]]; then
    echo "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$($HOMEBREW_BASE/bin/brew shellenv)"

if [[ ! -d "$HOME/.dotfiles" ]]; then
    echo "Cloning dotfiles"
    git clone --recursive https://github.com/bryanforbes/dotfiles "$HOME/.dotfiles"
fi

ZSHPATH="$HOMEBREW_BASE/bin/zsh"
echo "Adding $ZSHPATH to /etc/shells"
echo "$ZSHPATH" | sudo tee -a /etc/shells > /dev/null
chsh -s $ZSHPATH

$HOMEBREW_BASE/bin/zsh --no-rcs --no-globalrcs -c "source $HOME/.dotfiles/home/zshenv; source $HOME/.dotfiles/home/zshrc; dotfiles"

echo "Done"
