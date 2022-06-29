for DOTFILE in `find ~/.dotfiles/shell`
do
  if [[ "$DOTFILE" != *".zshrc"* ]]; then
    [ -f "$DOTFILE" ] && source "$DOTFILE"
  fi
done

# Load Oh My ZSH
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
