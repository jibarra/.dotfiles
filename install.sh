#! /bin/bash

read -p "Is this a home installation? yes/no" installation

if [[ $installation == 'yes' ]]; then
  echo "Starting a home installation"
else
  echo "Starting a non-home installation"
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew and install if we don't have it
# https://brew.sh
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file Brewfile/Brewfile-common

if [[ $installation == 'yes' ]]; then
  brew bundle --file Brewfile/Brewfile-home
fi

# Make ZSH the default shell environment
chsh -s $(which zsh)
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

source zsh_powerlevel9k_theme.sh
source ssh_key_to_keychain.sh
source link_dotfiles.sh

