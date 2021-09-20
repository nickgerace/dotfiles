if [ "$IS_WSL2" = "true" ] && [ "$(command -v docker)" ]; then
    function wsl2-docker {
        if [ ! $1 ] || [ "$1" = "" ]; then
            echo "command required: start status stop"
            return
        fi
        sudo service docker $1
    }
fi
