function apt-purge {
    if [ ! $1 ] || [ "$1" = "" ]; then
        echo "must specify package to be removed"
        return
    fi
    sudo apt purge -y $1
    sudo apt autoremove -y
}
