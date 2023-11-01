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

if [ $(command -v stow) ]; then
    stow --restow 
else
    ln -s $HOME/.dotfiles/bash/dot-bashrc $HOME/.bashrc
    ln -s $HOME/.dotfiles/bash/dot-profile $HOME/.bash_profile
    ln -s $HOME/.dotfiles/bash/dot-bashrc.d $HOME/.bashrc.d
    ln -s $HOME/.dotfiles/shell/dot-inputrc $HOME/.inputrc
    if [ ! -d "$HOME/.config" ]; then
        mkdir -p $HOME/.config
    fi
    ln -s $HOME/.dotfiles/tmux/dot-config/tmux $HOME/.config/tmux
fi