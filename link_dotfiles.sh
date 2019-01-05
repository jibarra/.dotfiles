#! /bin/sh

# Link default config locations to the ones in this folder
now=$(date)
mkdir ~/.dotfiles/backups/$now

mv ~/.gitconfig backups/$now
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
mv ~/.gitmessage.txt backups/$now
ln -s ~/.dotfiles/git/.gitmessage.txt ~/.gitmessage.txt
mv ~/.gitignore_global backups/$now
ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
mv ~/.ssh/config backups/$now
ln -s ~/.dotfiles/ssh/config ~/.ssh/config
mv ~/.zshrc backups/$now
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc
