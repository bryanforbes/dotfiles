#!/bin/sh
RIGHT_NOW=$( date +%Y%m%d%H%M%S )

REPLACE_ALL=0

prompt_overwrite() {
	local file="$1"
	shift

	echo -n "Overwrite ~/.$file? [ynaq] "

	read inputline
	local line="$inputline"

	case "$line" in
		y)
			return 1
		;;
		a)
			REPLACE_ALL=1
			return 1
		;;
		q)
			exit
		;;
		*)
			return 0
		;;
	esac
}

replace_file() {
	local file="$1"
	shift

	RETVAL=1
	if [ -f ~/.$file ] || [ -d ~/.$file ] || [ -h ~/.$file ]; then
		if [ $REPLACE_ALL -eq 0 ]; then
			prompt_overwrite $file
			RETVAL=$?
		fi
		if [ $RETVAL -eq 0 ]; then
			echo "\tSkipping ~/.$file"
			return
		fi
		echo "\tBacking up ~/.$file to ~/.$file.$RIGHT_NOW"
		mv ~/.$file ~/.$file.$RIGHT_NOW
	fi
	echo "\tLinking $PWD/$file to ~/.$file"
	ln -s $PWD/$file ~/.$file
}

for file in $( ls ); do
	if [ "${file}" = "install.sh" ] || [ "${file}" = "README.md" ]; then
		continue
	fi
	replace_file $file
done
