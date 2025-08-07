if [ "$NICK_OS" = "arch" ]; then
  ulimit -Sn 16384

  alias aur-list-packages="paru -Qua"
  alias paru-list-packages="paru -Qua"
  alias aur-upgrade-packages="paru -Sua"
  alias paru-upgrade-packages="paru -Sua"
fi
