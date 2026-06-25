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
mkdir ~/.dotfiles/backups/"${now}"/zed
mv ~/.config/zed/settings.json ~/.dotfiles/backups/"${now}"/zed
mv ~/.config/zed/keymap.json ~/.dotfiles/backups/"${now}"/zed
mkdir ~/.config/zed
ln -F -s ~/.dotfiles/config/zed/settings.json ~/.config/zed/settings.json
ln -F -s ~/.dotfiles/config/zed/keymap.json ~/.config/zed/keymap.json

# Claude config
mkdir ~/.dotfiles/backups/"${now}"/claude
mv ~/.claude/CLAUDE.md ~/.dotfiles/backups/"${now}"/claude
mv ~/.claude/settings.json ~/.dotfiles/backups/"${now}"/claude
mv ~/.claude/commands ~/.dotfiles/backups/"${now}"/claude
mv ~/.claude/hooks ~/.dotfiles/backups/"${now}"/claude
mv ~/.claude/skills ~/.dotfiles/backups/"${now}"/claude
mv ~/.claude/agents ~/.dotfiles/backups/"${now}"/claude
mkdir ~/.claude
ln -F -s ~/.dotfiles/config/ai_coding_harness/AGENTS.md ~/.claude/CLAUDE.md
ln -F -s ~/.dotfiles/config/claude/settings.json ~/.claude/settings.json
ln -F -s ~/.dotfiles/config/claude/commands ~/.claude/commands
ln -F -s ~/.dotfiles/config/claude/hooks ~/.claude/hooks
ln -F -s ~/.dotfiles/config/claude/skills ~/.claude/skills
ln -F -s ~/.dotfiles/config/claude/agents ~/.claude/agents

# opencode config
mkdir ~/.dotfiles/backups/"${now}"/opencode
mv ~/.config/opencode/opencode.jsonc ~/.dotfiles/backups/"${now}"/opencode
mv ~/.config/opencode/tui.json ~/.dotfiles/backups/"${now}"/opencode
mv ~/.config/opencode/plugin.json ~/.dotfiles/backups/"${now}"/opencode
mv ~/.config/opencode/opencode-notifier.json ~/.dotfiles/backups/"${now}"/opencode
mkdir ~/.config/opencode
ln -F -s ~/.dotfiles/config/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -F -s ~/.dotfiles/config/opencode/tui.json ~/.config/opencode/tui.json
ln -F -s ~/.dotfiles/config/opencode/plugin.json ~/.config/opencode/plugin.json
ln -F -s ~/.dotfiles/config/opencode/opencode-notifier.json ~/.config/opencode/opencode-notifier.json
mkdir ~/.config/opencode/plugins
ln -F -s ~/.dotfiles/config/opencode/plugins/notifier-path-resolver.js ~/.config/opencode/plugins/notifier-path-resolver.js

