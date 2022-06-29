#! /bin/bash

# Display all files in Finder
defaults write com.apple.Finder AppleShowAllFiles TRUE
# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

killall Finder

# Dock show/hide time
# No wait
defaults write com.apple.dock autohide-time-modifier -int 0
# Slight wait
# defaults write com.apple.dock autohide-time-modifier -float 0.15
# Remove animation during show
defaults write com.apple.dock autohide-delay -float 0
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

killall Dock

# Keyboard key repeat time
# Time to initial repeat
defaults write -g InitialKeyRepeat -int 25
# Subsequent repeat times
defaults write -g KeyRepeat -int 1

# Trackpad tracking speed
defaults write -g com.apple.mouse.scaling -float 2.0

# Disable auto spelling correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable auto text completion
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
# Disable auto capitalization while typing
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable auto periods while typing
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disable smart dashes while typing
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Always show scroll bars
defaults write -g AppleShowScrollBars -string "Always"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "MacOS settings changed. Please restart to ensure settings take effect."

