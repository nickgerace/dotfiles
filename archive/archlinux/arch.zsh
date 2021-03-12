function paru-push {
    paru -Qqen > $DOTFILES/archive/archlinux/PKGLIST
    paru -Qqm > $DOTFILES/archive/archlinux/AURLIST
}

function paru-install {
    paru -Sy - < $DOTFILES/archive/archlinux/PKGLIST
    paru -Sy - < $DOTFILES/archive/archlinux/AURLIST
}

function paru-up {
    paru -Syu
    paru -Sua
}
