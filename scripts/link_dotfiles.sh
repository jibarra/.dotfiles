#! /bin/bash

# Link default config locations to the ones in this folder
now=$(date)
mkdir ~/.dotfiles/backups/"${now}"

# Git config
mv ~/.gitconfig ~/.dotfiles/backups/"${now}"
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig

# SSH config
mv ~/.ssh/config ~/.dotfiles/backups/"${now}"
ln -s ~/.dotfiles/ssh/config ~/.ssh/config

# ZSH config
mv ~/.zshrc ~/.dotfiles/backups/"${now}"
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc

# Alacritty config
mv ~/.config/alacritty.toml ~/.dotfiles/backups/"${now}"
mkdir ~/.config
ln -F -s ~/.dotfiles/config/alacritty/alacritty.toml ~/.config/alacritty.toml
