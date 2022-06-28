#! /bin/bash

# Link default config locations to the ones in this folder
now=$(date)
mkdir ~/.dotfiles/backups/"${now}"

mv ~/.gitconfig ~/.dotfiles/backups/"${now}"
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
mv ~/.ssh/config ~/.dotfiles/backups/"${now}"
ln -s ~/.dotfiles/ssh/config ~/.ssh/config
mv ~/.zshrc ~/.dotfiles/backups/"${now}"
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc
