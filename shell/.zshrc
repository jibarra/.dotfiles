for DOTFILE in `find ~/.dotfiles/shell`
do
  [ -f “$DOTFILE” ] && source “$DOTFILE”
done
