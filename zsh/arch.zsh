function paru-push {
    paru -Qqen > ${HOME}/dotfiles/archive/archlinux/PKGLIST
    paru -Qqm > ${HOME}/dotfiles/archive/archlinux/AURLIST
}

function paru-install {
    paru -Sy - < ${HOME}/dotfiles/archive/archlinux/PKGLIST
    paru -Sy - < ${HOME}/dotfiles/archive/archlinux/AURLIST
}

function paru-up {
    paru -Syu
    paru -Sua
}
