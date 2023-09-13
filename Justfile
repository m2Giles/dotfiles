install:
	#!/usr/bin/env bash
	
	if [ -L ~/.bashrc ]; then
		echo "~/.bashrc is a symlink"
	elif [ -f ~/.bashrc ]; then
		mv ~/.bashrc ~/.bashrc.orig
		echo "Backed up .bashrc"
	fi
	if [ -L ~/.bash_profile ]; then
		echo "~/.bash_profile is a symlink"
	elif [ -f ~/.bash_profile ]; then
		mv ~/.bash_profile ~/.bash_profile.orig
		echo "Backed up .bash_profile"
	fi
	stow --restow */
remove:
	#!/usr/bin/env bash
	stow --delete */
	if [ -f ~/.bash_profile.orig ]; then
		mv ~/.bash_profile.orig ~/.bash_profile
	fi
	if [ -f ~/.bashrc.orig ]; then
		mv ~/.bashrc.orig ~/.bashrc
	fi
