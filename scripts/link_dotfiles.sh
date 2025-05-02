#! /bin/bash

# Link default config locations to the ones in this folder
now=$(date)
mkdir ~/.dotfiles/backups/"${now}"

# Git config
mv ~/.gitconfig ~/.dotfiles/backups/"${now}"
ln -F -s ~/.dotfiles/config/git/.gitconfig ~/.gitconfig

# SSH config
mv ~/.ssh/config ~/.dotfiles/backups/"${now}"
ln -F -s ~/.dotfiles/config/ssh/config ~/.ssh/config

# ZSH config
mv ~/.zshrc ~/.dotfiles/backups/"${now}"
ln -F -s ~/.dotfiles/config/shell/.zshrc ~/.zshrc

# Alacritty config
mv ~/.config/alacritty.toml ~/.dotfiles/backups/"${now}"
mkdir ~/.config
ln -F -s ~/.dotfiles/config/alacritty/alacritty.toml ~/.config/alacritty.toml

# Zed config
mv ~/.config/zed/settings.json ~/.dotfiles/backups/zed/"${now}"
mv ~/.config/zed/keymap.json ~/.dotfiles/backups/zed/"${now}"
mkdir ~/.config/zed
ln -F -s ~/.dotfiles/config/zed/settings.json ~/.config/zed/settings.json
ln -F -s ~/.dotfiles/config/zed/keymap.json ~/.config/zed/keymap.json

