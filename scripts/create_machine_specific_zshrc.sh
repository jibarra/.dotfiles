MACHINE_ZSHRC=~/.dotfiles/config/shell/.machine_specific_zshrc

# Back up any existing machine config before overwriting it.
if [ -f "$MACHINE_ZSHRC" ]; then
  backup_dir=~/.dotfiles/backups/"$(date)"
  mkdir -p "$backup_dir"
  cp "$MACHINE_ZSHRC" "$backup_dir"/.machine_specific_zshrc
fi

cat > "$MACHINE_ZSHRC" <<EOF
# Specific to this machine. Written by ./install.sh, which sets DOTFILES_ENV
# here. Only these comments are committed — local values are kept out of the
# repo with: git update-index --skip-worktree config/shell/.machine_specific_zshrc

git -C ~/.dotfiles update-index --skip-worktree config/shell/.machine_specific_zshrc

export DOTFILES_ENV="${DOTFILES_ENV}"

