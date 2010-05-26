#!/bin/sh
RIGHT_NOW=$( date +%Y%m%d%H%M%S )

for file in $( ls ); do
	if [ "${file}" = "install.sh" ] || [ "${file}" = "README.md" ]; then
		continue
	fi
	if [ -f ~/.$file ] || [ -d ~/.$file ] || [ -h ~/.$file ]; then
		mv ~/.$file ~/.$file.$RIGHT_NOW
		ln -s $PWD/$file ~/.$file
	fi
done
