if [ "$(command -v kubectl)" ] && [ -d $HOME/.krew ]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
  alias krew-update="kubectl krew update && kubectl krew upgrade"
fi
