function paru-push {
    paru -Qqe > ${HOME}/dotfiles/archlinux/PKGLIST
    paru -Qqm > ${HOME}/dotfiles/archlinux/AURLIST
}

function paru-install {
    paru -Sy - < ${HOME}/dotfiles/archlinux/PKGLIST
    paru -Sy - < ${HOME}/dotfiles/archlinux/AURLIST
}

function paru-upgrade {
    paru -Syu
    paru -Sua
}
