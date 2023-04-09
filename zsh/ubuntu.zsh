if [ "$(command -v apt)" ]; then 
    function apt-purge {
        if [ ! $1 ] || [ "$1" = "" ]; then
            echo "must specify package to be removed"
            return
        fi
        sudo apt purge $1
        sudo apt autoremove -y
    }

    alias apt-install-deb="sudo dpkg -i"
fi
