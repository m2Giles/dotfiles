# vim:ft=bash
install:
	#!/usr/bin/env bash
	if [ -f ~/.bash_profile ] && [ ! -s ~/.bash_profile ]; then
		mv ~/.bash_profile ~/.bash_profile.orig
		echo "Backed up .bash_profile"
	fi
	if [ -f ~/.gitconfig ] && [ ! -s ~/.gitconfig ]; then
		mv ~/.gitconfig ~/.gitconfig.orig
		echo "Backed up .gitconfig"
	fi
	stow --verbose --target=$HOME --restow */

remove:
	#!/usr/bin/env bash
	stow --verbose --target=$HOME --delete */
	if [ -f ~/.bash_profile.orig ]; then
		mv ~/.bash_profile.orig ~/.bash_profile
	fi
	if [ -f ~/.gitconfig.orig ]; then
		mv ~/.gitconfig.orig ~/.gitconfig
	fi
