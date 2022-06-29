#! /bin/bash

# Display all files in Finder
defaults write com.apple.Finder AppleShowAllFiles TRUE

killall Finder

# Dock show/hide time
# No wait
defaults write com.apple.dock autohide-time-modifier -int 0
# Slight wait
# defaults write com.apple.dock autohide-time-modifier -float 0.15
# Remove animation during show
defaults write com.apple.dock autohide-delay -float 0

killall Dock

# Keyboard key repeat time
# Time to initial repeat
defaults write -g InitialKeyRepeat -int 25
# Subsequent repeat times
defaults write -g KeyRepeat -int 1

# Trackpad tracking speed
defaults write -g com.apple.mouse.scaling -float 2.0

