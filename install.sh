#! /bin/sh

# Check for Homebrew and install if we don't have it
# https://brew.sh
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Make ZSH the default shell environment
chsh -s $(which zsh)

source defaults.sh

source link_dotfiles.sh

# Set macOS preferences
# Ran last because it restarts the shell and computer
source osx_defaults.sh
