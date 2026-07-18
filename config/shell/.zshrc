# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Sets DOTFILES_ENV (home/work) and any other per-machine values. Sourced
# first so the config files below can branch on it. The loop skips it via the
# *.zshrc* exclusion.
source ~/.dotfiles/config/shell/.machine_specific_zshrc

for DOTFILE in `find ~/.dotfiles/config/shell`
do
  if [[ "$DOTFILE" != *".zshrc"* ]]; then
    [ -f "$DOTFILE" ] && source "$DOTFILE"
  fi
done

# Load Oh My ZSH
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f .p10k.zsh ]] || source .p10k.zsh

