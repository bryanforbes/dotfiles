lpath=()
lmanpath=()
lcdpath=()

case "$(uname)" in
	Darwin)
		lpath=(/usr/local/opt/coreutils/libexec/gnubin /usr/local/share/npm/bin /usr/local/bin /usr/local/sbin)
		lmanpath=(/usr/local/opt/coreutils/libexec/gnuman)
		;;
esac

if [ -e "$HOME/Projects" ]; then
	lcdpath+="$HOME/Projects"
	if [ -e "$HOME/Projects/sitepen" ]; then
		lcdpath+="$HOME/Projects/sitepen"
	fi
	if [ -e "$HOME/Projects/pebble/PebbleSDK-current" ]; then
		lpath=(~/Projects/pebble/PebbleSDK-current/bin $lpath)
	fi
fi

cdpath=($cdpath $lcdpath)
path=(~/bin ~/.dotfiles/bin $lpath $path)
manpath=($lmanpath $manpath)

# Clean up
unset lpath lmanpath lcdpath
