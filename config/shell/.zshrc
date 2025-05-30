# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

for DOTFILE in `find ~/.dotfiles/config/shell`
do
  if [[ "$DOTFILE" != *".zshrc"* ]]; then
    [ -f "$DOTFILE" ] && source "$DOTFILE"
  fi
done

source ~/.machine_specific_zshrc

# Load Oh My ZSH
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f .p10k.zsh ]] || source .p10k.zsh

