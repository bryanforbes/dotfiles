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
		sudo apt-add-repository ppa:git-core/ppa
		sudo apt-get update
		sudo apt-get install git zsh vim || true
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

echo "Setting up ViM environment"
true | vim -u ~/.dotfiles/install.vim +PluginInstall +qa 2>/dev/null

echo "Installing nvm"
git clone https://github.com/creationix/nvm.git ~/.nvm
source ~/.nvm/nvm.sh

echo "Installing node"
nvm install 0.10
nvm alias default 0.10

chsh -s $ZSHPATH
