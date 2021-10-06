if [ "$NICK_WSL2" = "true" ]; then
    # Change to the home directory on WSL2.
    if [[ "$PWD" == "/mnt/c/Users/"* ]]; then
        cd $HOME
    fi

    if [ "$(command -v docker)" ]; then
        function wsl2-docker {
            if [ ! $1 ] || [ "$1" = "" ]; then
                echo "command required: start status stop"
                return
            fi
            sudo service docker $1
        }
    fi
fi
