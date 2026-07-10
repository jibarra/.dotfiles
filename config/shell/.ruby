rbenv_exists=$(which -s rbenv)
if [[ $? = 0 ]]; then
  eval "$(rbenv init - zsh)"
fi

