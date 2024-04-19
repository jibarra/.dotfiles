#! /bin/bash

read -p "What type of installation? home/work " installation

if [[ $installation == 'home' ]]; then
  echo "Starting a home installation"
elif [[ $installation == 'work' ]]; then
  echo "Starting a work installation"
else
  echo "Incorrect installation type given"
  exit 1
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew and install if we don't have it
# https://brew.sh
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file Brewfile/Brewfile-common

if [[ $installation == 'home' ]]; then
  brew bundle --file Brewfile/Brewfile-home
elif [[ $installation == 'work' ]]; then
  brew bundle --file Brewfile/Brewfile-work
fi

# Make ZSH the default shell environment
chsh -s $(which zsh)
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

source scripts/create_machine_specific_zshrc.sh
source scripts/create_machine_specific_gitconfig.sh
source scripts/zsh_powerlevel10k_theme.sh
source scripts/ssh_key_to_keychain.sh
source scripts/zsh_install_syntax_highlighting.sh
source scripts/link_dotfiles.sh
source scripts/macos_defaults.sh

