#! /bin/bash

# Add ssh key to keychain: https://apple.stackexchange.com/questions/48502/how-can-i-permanently-add-my-ssh-private-key-to-keychain-so-it-is-automatically
ssh-add --apple-use-keychain ~/.ssh/id

