#!/bin/sh

UNAME="$(uname)"

case "$UNAME" in
	Darwin)
		echo "Requesting Installation of Command Line Tools"
		xcode-select --install

		if [ ! -d "/usr/local/Cellar" ]; then
			echo "Installing Homebrew"
			ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
		fi

		echo "Installing homebrew packages"
		brew install git --without-completions
		brew install hub --without-completions
		brew install vim git-archive-all zsh tmux coreutils gnu-sed gnupg reattach-to-user-namespace ack fasd nginx dnsmasq mobile-shell python neovim

		mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf.installed
		mv /usr/local/etc/dnsmasq.conf /usr/local/etc/dnsmasq.conf.installed

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
ln -s ~/.dotfiles/zsh ~/.zprezto
ln -s ~/.dotfiles/zsh/runcoms/zlogin ~/.zlogin
ln -s ~/.dotfiles/zsh/runcoms/zlogout ~/.zlogout
ln -s ~/.dotfiles/zsh/runcoms/zpreztorc ~/.zpreztorc
ln -s ~/.dotfiles/zsh/runcoms/zprofile ~/.zprofile
ln -s ~/.dotfiles/zsh/runcoms/zshenv ~/.zshenv
ln -s ~/.dotfiles/zsh/runcoms/zshrc ~/.zshrc

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

case "$UNAME" in
	Darwin)
		ln -sf ~/.dotfiles/osx/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf
		ln -sf ~/.dotfiles/osx/nginx/common /usr/local/etc/nginx/common
		ln -sf ~/.dotfiles/osx/nginx/fpm /usr/local/etc/nginx/fpm
		ln -sf ~/.dotfiles/osx/nginx/servers/test /usr/local/etc/nginx/servers/test

		mkdir /usr/local/etc/dnsmasq.d
		ln -sf ~/.dotfiles/osx/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf
		ln -sf ~/.dotfiles/osx/dnsmasq/hosts.dnsmasq /usr/local/etc/hosts.dnsmasq
		ln -sf ~/.dotfiles/osx/dnsmasq/dnsmasq.d/test.conf /usr/local/etc/dnsmasq.d/test.conf

		sudo ln -sf ~/.dotfiles/osx/test.resolver /etc/resolver/test

		sudo brew services dnsmasq start
		sudo brew services nginx start
		brew services start php55
	;;
esac

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
