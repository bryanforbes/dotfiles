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
    HOMEBREW_BASE=/usr/local
else
    HOMEBREW_BASE=/home/linuxbrew/.linuxbrew
fi

if [[ ! -d "$HOMEBREW_BASE" ]]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

eval "$($HOMEBREW_BASE/bin/brew shellenv)"

if [[ ! -d "$HOME/.dotfiles" ]]; then
    echo "Cloning dotfiles"
    git clone --recursive https://github.com/bryanforbes/dotfiles ~/.dotfiles
fi

brew bundle install --file="$HOME/.dotfiles/Brewfile"

ZSHPATH="$HOMEBREW_BASE/bin/zsh"
echo "Adding $ZSHPATH to /etc/shells"
sudo -s "echo $ZSHPATH >> /etc/shells"
chsh -s $ZSHPATH

$HOMEBREW_BASE/bin/zsh --no-rcs --no-globalrcs -c "source $HOME/.dotfiles/home/zshenv; source $HOME/.dotfiles/home/zshrc; dotfiles"

echo "Done"
