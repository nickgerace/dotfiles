function paru-push {
    paru -Qqen > ${HOME}/dotfiles/archlinux/PKGLIST
    paru -Qqm > ${HOME}/dotfiles/archlinux/AURLIST
}

function paru-install {
    paru -Sy - < ${HOME}/dotfiles/archlinux/PKGLIST
    paru -Sy - < ${HOME}/dotfiles/archlinux/AURLIST
}

function paru-up {
    paru -Syu
    paru -Sua
}
