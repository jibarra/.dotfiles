#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Uninstall Google Update
~/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall --nuke

# SSH
# ssh-add -K /path/to/private_key
# Then in ~/.ssh/config
# Host server.example.com
#     IdentityFile /path/to/private_key
#     UseKeychain yes

###############################################################################
# Mackup                                                                      #
###############################################################################


###############################################################################
# Sublime Text                                                                #
###############################################################################

# Install Sublime Text settings
# cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

###############################################################################
# Spectacle.app                                                               #
###############################################################################

# Set up my preferred keyboard shortcuts
# cp -r init/spectacle.json ~/Library/Application\ Support/Spectacle/Shortcuts.json 2> /dev/null
