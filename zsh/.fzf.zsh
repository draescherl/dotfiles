# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lucas/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/lucas/.fzf/bin"
fi

eval "$(fzf --zsh)"
