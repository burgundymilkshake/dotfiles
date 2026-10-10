# Setup fzf
# ---------
if [[ ! "$PATH" == */home/mreddy7/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/mreddy7/.fzf/bin"
fi

source <(fzf --zsh)
