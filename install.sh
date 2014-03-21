#!/bin/sh

GET=
case "$(uname)" in
	Darwin)
		echo "Requesting Installation of Command Line Tools"
		xcode-select --install

		if [ ! -d "/usr/local/Cellar" ]; then
			echo "Installing Homebrew"
			ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
		fi

		brew install git --without-completions
		brew install zsh --disable-etcdir
		brew install macvim --override-system-vim
		brew install coreutils gnupg tmux reattach-to-user-namespace the_silver_searcher

		ZSHPATH=$(which zsh)
		echo "Adding $ZSHPATH to /etc/shells"
		sudo -s "echo $ZSHPATH >> /etc/shells"
		;;
	Linux)
		# TODO: add linux commands
		sudo apt-add-repository ppa:git-core/ppa
		sudo apt-get update
		sudo apt-get install git zsh vim || true
		ZSHPATH=$(which zsh)
		;;
esac

echo "Cloning dotfiles"
git clone --recursive https://github.com/bryanforbes/dotfiles ~/.dotfiles

echo "Installing oh-my-zsh"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo "Linking dotfiles"
ln -s ~/.dotfiles/editorconfig ~/.editorconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/gitignore ~/.gitignore
ln -s ~/.dotfiles/gvimrc ~/.gvimrc
ln -s ~/.dotfiles/jshintrc ~/.jshintrc
ln -s ~/.dotfiles/tmux ~/.tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/zsh ~/.zsh
ln -s ~/.dotfiles/zshrc ~/.zshrc

echo "Setting up ViM environment"
vim -c BundleInstall -c q -c q

chsh -s $ZSHPATH
