#! /bin/bash

# Display all files in Finder
defaults write com.apple.Finder AppleShowAllFiles TRUE

killall Finder

# Dock show/hide time
# No animation
defaults write com.apple.dock autohide-time-modifier -int 0
# Slight animation
# defaults write com.apple.dock autohide-time-modifier -float 0.15

killall Dock

