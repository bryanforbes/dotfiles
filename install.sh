#!/bin/sh

case "$(uname)" in
	Darwin)
		echo "Requesting Installation of Command Line Tools"
		xcode-select --install

		if [ ! -d "/usr/local/Cellar" ]; then
			echo "Installing Homebrew"
			ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
		fi

		echo "Installing packages"
		brew install git --without-completions
		brew install hub --without-completions
		brew install vim zsh tmux coreutils gnu-sed gnupg reattach-to-user-namespace ack fasd todo-txt nginx dnsmasq
		brew tap homebrew/dupes
		brew tap homebrew/versions
		brew tap homebrew/php
		brew install php55 --with-fpm

		ZSHPATH=/usr/local/bin/zsh
		echo "Adding $ZSHPATH to /etc/shells"
		sudo -s "echo $ZSHPATH >> /etc/shells"
		;;
	Linux)
		# TODO: add linux commands
		echo "Installing packages"
		sudo apt-add-repository -y ppa:git-core/ppa
		sudo apt-add-repository -y ppa:neovim-ppa/stable
		sudo apt-get update
		sudo apt-get install -y git zsh tmux neovim python-dev python-pip python-setuptools python3-dev python3-pip python3-setuptools  || true
		pip2 install --user --upgrade neovim || true
		pip3 install --user --upgrade neovim || true
		ZSHPATH=$(which zsh)
		;;
esac

echo "Cloning dotfiles"
git clone --recursive https://github.com/bryanforbes/dotfiles ~/.dotfiles

echo "Installing prezto"
git clone --recursive https://github.com/bryanforbes/prezto.git --branch bryanforbes ~/.zprezto

ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
ln -s ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc

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
mkdir ~/.config
ln -s ~/.dotfiles/vim ~/.config/nvim

echo "Installing nvm"
git clone https://github.com/creationix/nvm.git ~/.nvm
source ~/.nvm/nvm.sh

echo "Installing node"
nvm install --lts

echo "Setting up ViM environment"
true | vim -u ~/.dotfiles/install.vim +PlugInstall +qa 2>/dev/null

echo "Setting up tmux environment"
true | ~/.dotfiles/tmux/plugins/tpm/bin/install_plugins > /dev/null 2>&1

chsh -s $ZSHPATH
