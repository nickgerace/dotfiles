if [ "$NICK_OS" = "arch" ]; then
  ulimit -Sn 16384

  alias arch-list-packages="pacman -Qe"
  alias arch-list-packages-names-only="pacman -Qqe"

  alias arch-list-aur-packages="paru -Qua"
  alias arch-upgrade-aur-packages="paru -Sua"
fi
